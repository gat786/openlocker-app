import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/services/common.service.dart';

class FileProvider with ChangeNotifier {
  late CommonService _commonService;

  late AuthProvider? authProvider;

  FileProvider({this.authProvider});

  List<File> _flatFiles = List.empty();

  FilesResponse? _hierarchicalFiles;

  FilesResponse? get hierarchicalFiles => _hierarchicalFiles;

  set hierarchicalFiles(FilesResponse? newResponse) {
    _hierarchicalFiles = newResponse;
    notifyListeners();
  }

  List<File> get flatFiles => _flatFiles;

  List<File> flatFilesByFilter({String discreteMimeType = ""}){
    if(discreteMimeType != "")
      return _flatFiles.where((element) => element.contentType?.startsWith(discreteMimeType) ?? false).toList();
    else
      return _flatFiles;
  }

  set flatFiles(dynamic newFiles) {
    _flatFiles = newFiles;
    notifyListeners();
  }

  Future getFlatFiles() async {
    try {
      var url = API_ENDPOINT + "blob/all";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}"
      };
      _commonService = await CommonService.getInstance();
      var response = await _commonService.get(url: url, headers: headers);
      if (response != null && response.toString().isNotEmpty) {
        var standardResponse = StandardResponse.fromJson(
            Map.from(jsonDecode(response.toString())));
        if (standardResponse.success == true) {
          flatFiles = FlatFilesResponse.fromJson(standardResponse.data).files;
        }
      }
    } on TokenExpiredException {
      await authProvider?.getAccessToken();
    }
  }

  Future<String?> getDownloadUri({required String fileName}) async {
    try {
      var url = API_ENDPOINT + "blob/download";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: ContentType.json.mimeType
      };
      var body = {"filename": fileName};
      _commonService = await CommonService.getInstance();
      var response = await _commonService.post(
          url: url, headers: headers, body: jsonEncode(body));

      if (response != null && response.toString().isNotEmpty) {
        var standardResponse = StandardResponse.fromJson(
            Map.from(jsonDecode(response.toString())));
        if (standardResponse.success == true) {
          return standardResponse.data as String;
        }
      }
    } on TokenExpiredException {
      await authProvider?.getAccessToken();
    }
  }

  Future<String?> getUploadUri({required String fileName}) async {
    try {
      var url = API_ENDPOINT + "blob/upload";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: ContentType.json.mimeType
      };
      var body = {"filename": fileName};
      _commonService = await CommonService.getInstance();
      var response = await _commonService.post(
          url: url, headers: headers, body: jsonEncode(body));

      if (response != null && response.toString().isNotEmpty) {
        var standardResponse = StandardResponse.fromJson(
            Map.from(jsonDecode(response.toString())));
        if (standardResponse.success == true) {
          return standardResponse.data as String;
        }
      }
    } on TokenExpiredException {
      await authProvider?.getAccessToken();
    }
  }

  Future deleteFile(String fileName) async {
    try {
      var url = API_ENDPOINT + "blob/delete";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: ContentType.json.mimeType
      };
      var body = {"filename": fileName };
      _commonService = await CommonService.getInstance();
      var response = await _commonService.post(
          url: url, headers: headers, body: jsonEncode(body));

      if (response != null && response.toString().isNotEmpty) {
        var standardResponse = StandardResponse.fromJson(
            Map.from(jsonDecode(response.toString())));
        if (standardResponse.success == true) {
          return standardResponse.data as String;
        }
      }
    } on TokenExpiredException {
      await authProvider?.getAccessToken();
    }
  }



  Future getHierarchicalFiles({prefix = ""}) async {
    try {
      var url = API_ENDPOINT + "blob";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: ContentType.json.mimeType
      };
      var body = {"prefix": prefix};
      _commonService = await CommonService.getInstance();
      var response = await _commonService.post(
          url: url, headers: headers, body: jsonEncode(body));

      if (response != null && response.toString().isNotEmpty) {
        var standardResponse = StandardResponse.fromJson(
            Map.from(jsonDecode(response.toString())));
        if (standardResponse.success == true) {
          hierarchicalFiles = FilesResponse.fromJson(standardResponse.data);
        }
      }
    } on TokenExpiredException {
      await authProvider?.getAccessToken();
    }
  }
}
