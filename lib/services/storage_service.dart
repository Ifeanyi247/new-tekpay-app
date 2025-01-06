import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'token';

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
}
