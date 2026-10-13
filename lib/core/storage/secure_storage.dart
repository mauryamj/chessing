import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kSecureGeminiApiKey = 'secure_gemini_api_key';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  static Future<String?> getGeminiApiKey() async {
    return _storage.read(key: _kSecureGeminiApiKey);
  }

  static Future<void> setGeminiApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      await _storage.delete(key: _kSecureGeminiApiKey);
    } else {
      await _storage.write(key: _kSecureGeminiApiKey, value: trimmed);
    }
  }

  static Future<void> deleteGeminiApiKey() async {
    await _storage.delete(key: _kSecureGeminiApiKey);
  }
}
