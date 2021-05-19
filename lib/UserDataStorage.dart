import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataStorage {
  static const _USERNAME_KEY = "username";
  static const _EMAIL_KEY = "email";
  static const _ID_KEY = "id";
  static const _PASSWORD_KEY = "password";
  static const _PHONENUMBER_KEY = "phoneNumber";

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

  Future<String> getPasswordAsync() async {
    return await _storage.read(key: _PASSWORD_KEY);
  }

  Future<void> setPasswordAsync(String value) async {
    return await _storage.write(key: _PASSWORD_KEY, value: value);
  }

  Future<String> getPhoneNumberAsync() async {
    return await _storage.read(key: _PHONENUMBER_KEY);
  }

  Future<void> setPhoneNumberAsync(String value) async {
    return await _storage.write(key: _PHONENUMBER_KEY, value: value);
  }
}
