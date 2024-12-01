import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  // Singleton pattern
 // String? accessToken;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

}
  final AuthService authService = AuthService();
