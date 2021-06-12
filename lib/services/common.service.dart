import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:open_locker_app/constants.dart';

class CommonService {

  late Dio dio;
  late CookieManager cookieManager;
  late CookieJar cookieJar;

  CommonService(){
    dio = new Dio();
    cookieJar= PersistCookieJar();
    cookieManager = new CookieManager(cookieJar);
    dio.interceptors.add(cookieManager);
    cookieJar.loadForRequest(Uri.parse(API_ENDPOINT));
  }

  Object get(String url, Map<String, String> headers) async {
    try {
      var response = await dio.get(url);
      return response;
    } on DioError catch (err) {
      print(err.response?.data);
      print(err.response?.headers);
    }
  }

  Object post(String url, Map<String, String> headers, dynamic body) async {
    try {
      var response =
      await dio.post(url, data: body, options: Options(headers: headers));
      return response;
    } on DioError catch (err) {
      print(err.response?.data);
      print(err.response?.headers);
    }
  }

  Object put(String url, Map<String, String> headers, dynamic body) async {
    try {
      var response = await dio.put(
          url, options: Options(headers: headers), data: body);
      return response;
    } on DioError catch (err) {
      print(err.response?.data);
      print(err.response?.headers);
    }
  }
}
