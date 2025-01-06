import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'auth_token';

  static GetStorage get box => _box;

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> setToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static String? getToken() {
    return _box.read<String>(_tokenKey);
  }

  static Future<void> removeToken() async {
    await _box.remove(_tokenKey);
  }
}
