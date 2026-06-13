import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isAvailable() async {
    try {
      final supported = await isSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return const <BiometricType>[];
    }
  }

  Future<bool> authenticateForLogin({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
        sensitiveTransaction: false,
      );
    } catch (_) {
      return false;
    }
  }

  String preferredBiometricLabel(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    }
    if (types.contains(BiometricType.fingerprint)) {
      return 'Touch ID';
    }
    return 'Biometrics';
  }
}
