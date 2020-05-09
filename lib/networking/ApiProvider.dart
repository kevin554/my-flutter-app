import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:myapps/networking/CustomException.dart';

class ApiProvider {

  Future<dynamic> get(String url) async {
    var responseJson;

    try {
      final response = await http.get(url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> post(String url, body) async {
    var responseJson;

    try {
      final response = await http.post(url, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> dioPost(String url, params) async {
    var responseJson;
    var dio = Dio();
    FormData formData = FormData.fromMap(params);

    try {
      final response = await dio.post(url, data: formData);
      responseJson = _dioResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> dioPost2(String url, params) async {
    var responseJson;
    var dio = Dio();
    FormData formData = FormData.fromMap(params);

    try {
      final response = await dio.post(url, data: formData);
      responseJson = _dioResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _response(/*http.Response */response) {
    switch (response.statusCode) {
      case 200:
      case 202:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _dioResponse(/*http.Response */response) {
    switch (response.statusCode) {
      case 200:
        return response.data['data']['mensaje'];
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

}