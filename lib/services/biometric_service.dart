import 'package:flutter/services.dart';

/// Biometric authentication service
/// Note: Requires local_auth package to be properly configured
class BiometricService {
  /// Check if biometrics are available on the device
  static Future<bool> canAuthenticate() async {
    try {
      // TODO: Implement with local_auth when package is configured
      // For now, return false to indicate biometrics not available
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Authenticate user with biometrics
  static Future<bool> authenticate({
    String reason = 'Please authenticate to access this note',
  }) async {
    try {
      // TODO: Implement with local_auth
      // For now, always return false
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Check if fingerprint is available
  static Future<bool> hasFingerprint() async {
    return false;
  }

  /// Check if face recognition is available
  static Future<bool> hasFaceId() async {
    return false;
  }
}

