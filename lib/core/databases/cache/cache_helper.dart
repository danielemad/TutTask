import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  //! Save data using key
  Future<void> saveData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  //! Get dynamic value
  Future<dynamic> getData({required String key}) async {
    return await _storage.read(key: key);
  }

  //! Get bool
  Future<bool?> getBool({required String key}) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  //! Get int
  Future<int?> getInt({required String key}) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  //! Get double
  Future<double?> getDouble({required String key}) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  //! Check if key exists
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  //! Remove one key
  Future<void> removeData({required String key}) async {
    await _storage.delete(key: key);
  }

  //! Clear all storage
  Future<void> clearData() async {
    await _storage.deleteAll();
  }
}
