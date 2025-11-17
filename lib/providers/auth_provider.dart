// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../services/mixpanel_service.dart';

/// AuthProvider - Manages authentication state
/// 
/// This provider handles all authentication-related operations including:
/// - Login (email/password, Google)
/// - Registration
/// - Logout
/// - Password reset
/// - User state management
/// 
/// Usage:
/// ```dart
/// final authProvider = Provider.of<AuthProvider>(context);
/// await authProvider.signIn(email, password);
/// ```
class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmail(email, password);
      
      if (userCredential != null) {
        _user = userCredential.user;
        
        // Track login event in analytics
        if (_user != null) {
          MixpanelService.instance.trackLogin(
            userId: _user!.uid,
            email: _user!.email ?? '',
            loginProvider: 'email',
          );
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'Sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null) {
        _user = userCredential.user;
        
        // Track login event in analytics
        if (_user != null) {
          MixpanelService.instance.trackLogin(
            userId: _user!.uid,
            email: _user!.email ?? '',
            loginProvider: 'google',
          );
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'Google sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register with email and password
  Future<bool> registerWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.registerWithEmail(email, password);
      
      if (userCredential != null) {
        _user = userCredential.user;
        
        // Send email verification
        await _user?.sendEmailVerification();
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Reset analytics user
      MixpanelService.instance.reset();
      
      await _authService.signOut();
      _user = null;
      _error = null;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reload user data
  Future<void> reloadUser() async {
    await _user?.reload();
    _user = _auth.currentUser;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
