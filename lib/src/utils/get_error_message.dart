import 'dart:convert';

import 'package:dio/dio.dart';

String? getErrorMessage(DioError error) {
  if (error.response == null) {
    return null;
  }
  if (error.response?.data == null) {
    return null;
  }
  Map<String, dynamic>? decodedResponse;
  try {
    decodedResponse = json.decode(error.response?.data) as Map<String, dynamic>;
  } on FormatException catch (_) {
    return null;
  }
  if (!decodedResponse.containsKey('msg')) {
    return error.response?.data;
  }
  return decodedResponse['msg'];
}
