import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric authentication service
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if biometrics are available on the device
  static Future<bool> canAuthenticate() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Authenticate user with biometrics
  static Future<bool> authenticate({
    String reason = 'Please authenticate to access this note',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  /// Check if fingerprint is available
  static Future<bool> hasFingerprint() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.fingerprint);
    } catch (e) {
      return false;
    }
  }

  /// Check if face recognition is available
  static Future<bool> hasFaceId() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.contains(BiometricType.face);
    } catch (e) {
      return false;
    }
  }

  /// Get a description of available biometric types
  static Future<String> getBiometricDescription() async {
    try {
      final biometrics = await getAvailableBiometrics();
      if (biometrics.contains(BiometricType.face)) {
        return 'Face ID';
      } else if (biometrics.contains(BiometricType.fingerprint)) {
        return 'Fingerprint';
      } else if (biometrics.contains(BiometricType.iris)) {
        return 'Iris';
      }
      return 'Biometrics';
    } catch (e) {
      return 'Biometrics';
    }
  }
}

