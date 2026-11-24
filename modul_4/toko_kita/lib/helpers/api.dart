
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:toko_kita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  // HTTP POST
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    http.Response? responseJson;

    try {
      final response = await http.post(
        Uri.parse(url.toString()),
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  // HTTP GET
  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    http.Response? responseJson;

    try {
      final response = await http.get(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  // HTTP DELETE
  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    http.Response? responseJson;

    try {
      final response = await http.delete(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  // Menangani response berdasarkan HTTP status code
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());

      case 422:
        throw InvalidInputException(response.body.toString());

      case 500:
      default:
        throw FetchDataException(
          'Error occurred while communicating with Server '
          'with StatusCode: ${response.statusCode}',
        );
    }
  }
}
