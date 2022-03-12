import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  static final storage = new FlutterSecureStorage();

  static Future<String?> readValue({required String key}) async {
    // Read value
    return await storage.read(key: key);
  }

  static Future<bool> deleteValue({required String key}) async {
    try {
      // Delete value
      await storage.delete(key: key);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> writeValue(
      {required String key, required String value}) async {
    try {
      // Write value
      await storage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
