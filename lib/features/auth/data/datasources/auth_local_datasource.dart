import '../../../../core/databases/cache/cache_helper.dart';

class AuthLocalDatasource {
  final CacheHelper cache;
  final String key = "cachedToken";
  AuthLocalDatasource({required this.cache});

  Future<void> cacheToken(String token) async {
    await cache.saveData(key: key, value: token);
  }

  Future<dynamic> getCachedToken() async {
    return await cache.getData(key: key);
  }

  Future<void> clearCachedToken() async {
    await cache.removeData(key: key);
  }
}
