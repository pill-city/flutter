import 'dart:convert';

import 'package:dio/dio.dart';

String? getErrorMessage(DioError error) {
  Map<String, dynamic>? decodedResponse;
  try {
    decodedResponse =
        json.decode(error.response.toString()) as Map<String, dynamic>;
  } on FormatException catch (_) {
    return null;
  }
  if (!decodedResponse.containsKey('msg')) {
    return error.response.toString();
  }
  return decodedResponse['msg'];
}
