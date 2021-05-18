import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataStorage {
  static const _USERNAME_KEY = "username";
  static const _EMAIL_KEY = "email";
  static const _ID_KEY = "id";
  final _storage = FlutterSecureStorage();

  Future<String> getUsernameAsync() async {
    return await _storage.read(key: _USERNAME_KEY);
  }

  Future<void> setUsernameAsync(String value) async {
    return await _storage.write(key: _USERNAME_KEY, value: value);
  }

  Future<int> getIdAsync() async {
    return int.parse(await _storage.read(key: _ID_KEY));
  }

  Future<void> setIdAsync(int value) async {
    return await _storage.write(key: _ID_KEY, value: value.toString());
  }

  Future<String> getEmailAsync() async {
    return await _storage.read(key: _EMAIL_KEY);
  }

  Future<void> setEmailAsync(String value) async {
    return await _storage.write(key: _EMAIL_KEY, value: value);
  }
}
