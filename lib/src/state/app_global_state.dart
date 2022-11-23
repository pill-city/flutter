import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pill_city/pill_city.dart';

const secureStorage = FlutterSecureStorage();
const secureStorageAccessTokenKey = "access_token";
const secureStorageExpiresKey = "expires";

class AppGlobalState extends ChangeNotifier {
  Future<void> setAccessToken(String accessToken, String expires) async {
    await secureStorage.write(
        key: secureStorageAccessTokenKey, value: accessToken);
    await secureStorage.write(
        key: secureStorageExpiresKey, value: expires.toString());
  }

  Future<String?> getAccessToken() async {
    var accessToken =
        await secureStorage.read(key: secureStorageAccessTokenKey);
    if (accessToken == null) {
      return null;
    }
    var expires = await secureStorage.read(key: secureStorageExpiresKey);
    if (expires == null) {
      return null;
    }
    var parsedExpires = int.parse(expires);
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    if (parsedExpires <= now) {
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'expires');
      return null;
    }
    return accessToken;
  }

  Future<PillCity> getAuthenticatedApi() async {
    var accessToken = await getAccessToken();
    if (accessToken == null) {
      return Future.error("No access token");
    }
    Dio dio = Dio(
      BaseOptions(
        baseUrl: PillCity.basePath,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000, // 60 seconds
      ),
    );

    var api = PillCity(
      dio: dio,
    );
    api.setBearerAuth("bearer", accessToken);
    return api;
  }
}
