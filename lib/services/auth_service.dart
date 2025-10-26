// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsers = 'users_data';
  static const String _keyCurrentUser = 'current_user';

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyCurrentUser);
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }

  // Sign up new user
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing users
    final usersJson = prefs.getString(_keyUsers);
    List<dynamic> users = [];
    if (usersJson != null) {
      users = json.decode(usersJson);
    }

    // Check if email already exists
    final existingUser = users.firstWhere(
          (user) => user['email'] == email,
      orElse: () => null,
    );

    if (existingUser != null) {
      return {
        'success': false,
        'message': 'Email already registered',
      };
    }

    // Create new user
    final newUser = {
      'name': name,
      'email': email,
      'password': password, // In production, hash this!
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add to users list
    users.add(newUser);
    await prefs.setString(_keyUsers, json.encode(users));

    // Set as current user and log in
    await prefs.setString(_keyCurrentUser, json.encode({
      'name': name,
      'email': email,
    }));
    await prefs.setBool(_keyIsLoggedIn, true);

    return {
      'success': true,
      'message': 'Account created successfully',
      'user': {
        'name': name,
        'email': email,
      },
    };
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing users
    final usersJson = prefs.getString(_keyUsers);
    if (usersJson == null) {
      return {
        'success': false,
        'message': 'No account found with this email',
      };
    }

    List<dynamic> users = json.decode(usersJson);

    // Find user with matching credentials
    final user = users.firstWhere(
          (user) => user['email'] == email && user['password'] == password,
      orElse: () => null,
    );

    if (user == null) {
      return {
        'success': false,
        'message': 'Invalid email or password',
      };
    }

    // Set as current user and log in
    await prefs.setString(_keyCurrentUser, json.encode({
      'name': user['name'],
      'email': user['email'],
    }));
    await prefs.setBool(_keyIsLoggedIn, true);

    return {
      'success': true,
      'message': 'Login successful',
      'user': {
        'name': user['name'],
        'email': user['email'],
      },
    };
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyCurrentUser);
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get current user
    final currentUserJson = prefs.getString(_keyCurrentUser);
    if (currentUserJson == null) {
      return {
        'success': false,
        'message': 'No user logged in',
      };
    }

    final currentUser = json.decode(currentUserJson);
    final oldEmail = currentUser['email'];

    // Get all users
    final usersJson = prefs.getString(_keyUsers);
    if (usersJson == null) {
      return {
        'success': false,
        'message': 'User data not found',
      };
    }

    List<dynamic> users = json.decode(usersJson);

    // Update user in users list
    final userIndex = users.indexWhere((user) => user['email'] == oldEmail);
    if (userIndex != -1) {
      users[userIndex]['name'] = name;
      users[userIndex]['email'] = email;
      await prefs.setString(_keyUsers, json.encode(users));
    }

    // Update current user
    await prefs.setString(_keyCurrentUser, json.encode({
      'name': name,
      'email': email,
    }));

    return {
      'success': true,
      'message': 'Profile updated successfully',
      'user': {
        'name': name,
        'email': email,
      },
    };
  }
}