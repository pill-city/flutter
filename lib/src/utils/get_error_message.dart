import 'dart:convert';

import 'package:dio/dio.dart';

String getErrorMessage(DioError error) {
  if (error.response == null) {
    return error.message;
  }
  if (error.response?.data == null) {
    return error.message;
  }
  Map<String, dynamic>? decodedResponse;
  try {
    decodedResponse = json.decode(error.response?.data) as Map<String, dynamic>;
  } on FormatException catch (_) {
    return error.message;
  }
  if (!decodedResponse.containsKey('msg')) {
    return error.response?.data;
  }
  return decodedResponse['msg'];
}
