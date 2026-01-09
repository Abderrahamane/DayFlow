// lib/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Get current user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return {
          'uid': user.uid,
          'email': user.email,
          'emailVerified': user.emailVerified,
          ...doc.data()!,
        };
      }
      // Return basic Firebase Auth data if Firestore doc doesn't exist
      return {
        'uid': user.uid,
        'name': user.displayName ?? 'User',
        'email': user.email,
        'emailVerified': user.emailVerified,
      };
    } catch (e) {
      print('Error getting user data from Firestore: $e');
      // Fallback to Firebase Auth data on error
      return {
        'uid': user.uid,
        'name': user.displayName ?? 'User',
        'email': user.email,
        'emailVerified': user.emailVerified,
      };
    }
  }

  // Sign up new user with email/password
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return {
          'success': false,
          'message': 'Failed to create account',
        };
      }

      // Update display name
      await user.updateDisplayName(name.trim());

      // Send email verification
      await user.sendEmailVerification();

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'emailVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Account created! Please check your email to verify.',
        'requiresVerification': true,
        'user': {
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'emailVerified': false,
        },
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password must be at least 6 characters';
          break;
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password sign-in is disabled';
          break;
        default:
          message = e.message ?? 'Sign up failed';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Login user with email/password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return {
          'success': false,
          'message': 'Login failed',
        };
      }

      // Check if email is verified
      if (!user.emailVerified) {
        return {
          'success': false,
          'message': 'Please verify your email before logging in',
          'requiresVerification': true,
        };
      }

      // Try to update last login timestamp in Firestore (non-blocking)
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
          'emailVerified': user.emailVerified,
        });
      } catch (e) {
        print('Warning: Could not update Firestore: $e');
        // Continue anyway - Firestore update is not critical for login
      }

      // Get user data from Firestore
      Map<String, dynamic>? userData;
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        userData = userDoc.data();
      } catch (e) {
        print('Warning: Could not fetch user data from Firestore: $e');
        // Continue with basic user data
      }

      return {
        'success': true,
        'message': 'Login successful',
        'user': {
          'uid': user.uid,
          'name': userData?['name'] ?? user.displayName ?? 'User',
          'email': user.email,
          'emailVerified': user.emailVerified,
        },
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // sign in with google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Sign out first to ensure fresh sign-in (fixes some issues)
      await googleSignIn.signOut();

      // Trigger Google Sign-In flow
      print('🔐 Starting Google Sign-In flow...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('🔐 Google Sign-In cancelled by user');
        return {
          'success': false,
          'message': 'Sign-in cancelled',
        };
      }

      print('🔐 Google user obtained: ${googleUser.email}');

      // Get auth details
      print('🔐 Getting authentication tokens...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print(
          '🔐 Got tokens - accessToken: ${googleAuth.accessToken != null}, idToken: ${googleAuth.idToken != null}');

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      print('🔐 Signing in to Firebase...');
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        print('🔐 Firebase sign-in returned null user');
        return {
          'success': false,
          'message': 'Google sign-in failed',
        };
      }

      print('🔐 Firebase sign-in successful: ${user.uid}');

      // Create/update user in Firestore
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'User',
          'email': user.email,
          'emailVerified': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('🔐 Firestore user document updated');
      } catch (e) {
        print('⚠️ Firestore update failed (non-critical): $e');
      }

      return {
        'success': true,
        'message': 'Signed in with Google',
        'user': {
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
        },
      };
    } on FirebaseAuthException catch (e) {
      print('🔐 FirebaseAuthException: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': 'Firebase error: ${e.message}',
      };
    } catch (e) {
      print('🔐 Google Sign In Error Details: $e');
      String errorMessage = 'Google sign-in error';

      // Parse common errors
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorStr.contains('apiexception: 10')) {
        errorMessage =
            'Developer error: SHA-1 fingerprint not configured in Firebase Console.';
      } else if (errorStr.contains('apiexception: 12500')) {
        errorMessage =
            'Google Play Services error. Please update Google Play Services.';
      } else if (errorStr.contains('apiexception: 7')) {
        errorMessage = 'Network error. Please check your connection.';
      } else {
        errorMessage = 'Sign-in failed: ${e.toString().split('\\n').first}';
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Send email verification
  Future<Map<String, dynamic>> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'No user logged in',
        };
      }

      if (user.emailVerified) {
        return {
          'success': false,
          'message': 'Email is already verified',
        };
      }

      await user.sendEmailVerification();

      return {
        'success': true,
        'message': 'Verification email sent. Please check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'too-many-requests':
          message = 'Too many requests. Please wait before trying again.';
          break;
        default:
          message = e.message ?? 'Failed to send verification email';
      }
      return {
        'success': false,
        'message': message,
        'code': e.code,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
        'code': 'unknown',
      };
    }
  }

  // Reload user to check email verification status
  Future<bool> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        // Update Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'emailVerified': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error reloading user: $e');
      return false;
    }
  }

  // Send password reset email
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {
        'success': true,
        'message': 'Password reset email sent. Please check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Please try again later.';
          break;
        default:
          message = e.message ?? 'Failed to send reset email';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  // Change user password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return {
          'success': false,
          'message': 'No user logged in',
        };
      }

      // Re-authenticate user with current password (with timeout)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user
            .reauthenticateWithCredential(credential)
            .timeout(const Duration(seconds: 10));
      } on TimeoutException {
        return {
          'success': false,
          'message': 'Request timed out. Please check your connection.',
        };
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          return {
            'success': false,
            'message': 'Current password is incorrect',
          };
        }
        return {
          'success': false,
          'message': 'Authentication failed: ${e.message}',
        };
      }

      // Update password (with timeout)
      await user
          .updatePassword(newPassword)
          .timeout(const Duration(seconds: 10));

      return {
        'success': true,
        'message': 'Password changed successfully',
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timed out. Please try again.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'New password is too weak';
          break;
        case 'requires-recent-login':
          message = 'Please log out and log in again to change password';
          break;
        default:
          message = e.message ?? 'Failed to change password';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Update user profile
  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? email,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'No user logged in',
        };
      }

      // Update display name
      await user.updateDisplayName(name.trim());

      // Update email if provided and different
      if (email != null && email.trim() != user.email) {
        await user.updateEmail(email.trim());

        // Send verification email for new email
        await user.sendEmailVerification();

        // Try to update Firestore (non-blocking)
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'name': name.trim(),
            'email': email.trim(),
            'emailVerified': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }).timeout(const Duration(seconds: 5));
        } catch (e) {
          print('Firestore update failed: $e');
          // Continue anyway - profile is updated in Firebase Auth
        }

        return {
          'success': true,
          'message': 'Profile updated. Please verify your new email.',
          'requiresVerification': true,
        };
      }

      // Update Firestore (name only) - with timeout and error handling
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': name.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 5));
      } catch (e) {
        print('Firestore update failed, but Firebase Auth updated: $e');
        // Continue - name is already updated in Firebase Auth
      }

      return {
        'success': true,
        'message': 'Profile updated successfully',
        'user': {
          'uid': user.uid,
          'name': name.trim(),
          'email': user.email,
        },
      };
    } on TimeoutException {
      return {
        'success': true, // Still success because Firebase Auth updated
        'message': 'Profile updated (sync will retry later)',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'requires-recent-login':
          message = 'Please log out and log in again to update your profile';
          break;
        case 'email-already-in-use':
          message = 'This email is already in use';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Update failed';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'No user logged in',
        };
      }

      final uid = user.uid;

      // Delete all user data from Firestore
      await _deleteUserData(uid);

      // Delete auth account
      await user.delete();

      return {
        'success': true,
        'message': 'Account deleted successfully',
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return {
          'success': false,
          'message': 'Please log in again to delete your account',
          'requiresReauth': true,
        };
      }
      return {
        'success': false,
        'message': e.message ?? 'Failed to delete account',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Helper: Delete all user data from Firestore
  Future<void> _deleteUserData(String uid) async {
    try {
      final userDoc = _firestore.collection('users').doc(uid);

      // Delete subcollections
      final collections = ['habits', 'tasks', 'notes', 'journal'];
      for (var collection in collections) {
        final snapshot = await userDoc.collection(collection).get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Delete user document
      await userDoc.delete();
    } catch (e) {
      print('Error deleting user data: $e');
    }
  }
}
