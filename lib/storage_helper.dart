import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const storage = FlutterSecureStorage();

  static save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static read(String key) async {
    await storage.read(key: key);
  }
}
