import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:path_provider/path_provider.dart';

class CommonService {
  late Dio dio;
  late CookieManager cookieManager;
  late CookieJar cookieJar;

  static Future getInstance() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    CommonService service = new CommonService();
    service.dio = new Dio();
    service.cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    service.cookieManager = new CookieManager(service.cookieJar);
    service.dio.interceptors.add(service.cookieManager);
    service.cookieJar.loadForRequest(Uri.parse(API_ENDPOINT));
    return service;
  }

  static Future deleteCookies() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    CommonService service = new CommonService();
    service.cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    service.cookieJar.delete(Uri.parse(API_ENDPOINT));
  }

  Future<dynamic> get(
      {required String url,
      Map<String, String> headers = const {},
      ProgressCallback? downloadProgressCallback}) async {
    try {
      var response = await dio.get(url,
          options: Options(headers: headers),
          onReceiveProgress: downloadProgressCallback);
      return response;
    } on DioError catch (err) {
      print(err.response?.statusCode);
      print(err.response?.data);
      print(err.response?.headers);
      if (err.response?.statusCode == 401) {
        throw TokenExpiredException();
      }
    }
  }

  Future<Response?> post(
      {required String url, Map<String, String>? headers, dynamic body}) async {
    try {
      Response response =
          await dio.post(url, data: body, options: Options(headers: headers));
      return response;
    } on DioError catch (err) {
      print(err.response?.data);
      print(err.response?.headers);
      if (err.response?.statusCode == 401) {
        throw TokenExpiredException();
      }
      if (err.response?.statusCode == 422) {
        var response = StandardResponse.fromJson(err.response?.data);
        Fluttertoast.showToast(msg: response.message!);
      }
    }
  }

  Future<dynamic> put(
      {required String url,
      Map<String, String>? headers,
      dynamic body,
      ProgressCallback? onSendProgress}) async {
    try {
      var response = await dio.put(url,
          options: Options(headers: headers),
          data: body);
      return response;
    } on DioError catch (err) {
      print(err.response?.data);
      print(err.response?.headers);
      if (err.response?.statusCode == 401) {
        throw TokenExpiredException();
      }
    }
  }
}
