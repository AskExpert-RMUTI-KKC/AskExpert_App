
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class tokenStore {
  static final _storage = FlutterSecureStorage();

  static const _token = 'token';

  static Future<void> setToken(String jwt) async{
    await _storage.write(key: _token, value: jwt);
  }
  static Future<String?> getToken() async{
    return await _storage.read(key: _token);
  }
}