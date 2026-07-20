import 'dart:convert';

import '../../../../core/databases/cache/cache_helper.dart';

class AuthLocalDatasource {
  final CacheHelper _cache;
  final String _tokenKey = "cachedToken";
  AuthLocalDatasource({required this._cache});

  Future<void> saveToken(String token, DateTime dateTime) async {
    await _cache.saveData(
      key: _tokenKey,
      value: jsonEncode({
        "token": token,
        "expireDate": dateTime.toIso8601String(),
      }),
    );
  }

  Future<Map<String, dynamic>?> getCachedToken() async {
    final data = await _cache.getData(key: _tokenKey);

    if (data == null) return null;

    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> clearCachedToken() async {
    await _cache.removeData(key: _tokenKey);
  }
}
