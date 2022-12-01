import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pill_city/pill_city.dart';

const secureStorage = FlutterSecureStorage();
const secureStorageAccessTokenKey = "access_token";
const secureStorageExpiresKey = "expires";
const secureStorageCustomServerEnabledKey = "custom_server_enabled";
const secureStorageCustomServerAddressKey = "custom_server_address";

class AppGlobalState extends ChangeNotifier {
  Future<void> writeAccessToken(String accessToken, String expires) async {
    await secureStorage.write(
        key: secureStorageAccessTokenKey, value: accessToken);
    await secureStorage.write(
        key: secureStorageExpiresKey, value: expires.toString());
  }

  Future<String?> readAccessToken() async {
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

  Future<void> clearAccessToken() async {
    await secureStorage.delete(key: secureStorageAccessTokenKey);
    await secureStorage.delete(key: secureStorageExpiresKey);
  }

  Future<void> writeCustomServerSettings(
    bool enabled,
    String address,
  ) async {
    await secureStorage.write(
        key: secureStorageCustomServerEnabledKey, value: enabled ? "1" : "0");
    await secureStorage.write(
        key: secureStorageCustomServerAddressKey, value: address);
  }

  Future<PillCity> getUnauthenticatedApi() async {
    var customServerEnabled =
        await secureStorage.read(key: secureStorageCustomServerEnabledKey);
    var customServerAddress =
        await secureStorage.read(key: secureStorageCustomServerAddressKey);
    var basePath = PillCity.basePath;
    if (customServerEnabled == "1" && customServerAddress != null) {
      basePath = customServerAddress;
    }
    Dio dio = Dio(
      BaseOptions(
        baseUrl: basePath,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000, // 60 seconds
      ),
    );

    return PillCity(
      dio: dio,
    );
  }

  Future<PillCity> getAuthenticatedApi() async {
    var accessToken = await readAccessToken();
    if (accessToken == null) {
      return Future.error("No access token");
    }

    PillCity api = await getUnauthenticatedApi();
    api.setBearerAuth("bearer", accessToken);
    return api;
  }
}
