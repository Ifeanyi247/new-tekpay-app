import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'token';
  static const _biometricLoginKey = 'biometric_login';
  static const _biometricPaymentKey = 'biometric_payment';

  static GetStorage get box => _box;

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> setToken(String token) async {
    await _box.write(_tokenKey, token);
    await _box.save();
  }

  static String? getToken() {
    return _box.read<String>(_tokenKey);
  }

  static Future<void> removeToken() async {
    _box.remove('token');
    _box.remove('user_data');
    _box.remove('balance_visibility');
    await _box.save();
  }

  static Future<void> setBiometricLogin(bool enabled) async {
    await _box.write(_biometricLoginKey, enabled);
    await _box.save();
  }

  static Future<void> setBiometricPayment(bool enabled) async {
    await _box.write(_biometricPaymentKey, enabled);
    await _box.save();
  }

  static bool getBiometricLogin() {
    return _box.read<bool>(_biometricLoginKey) ?? false;
  }

  static bool getBiometricPayment() {
    return _box.read<bool>(_biometricPaymentKey) ?? false;
  }
}
