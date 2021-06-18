import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/services/common.service.dart';
import 'package:path_provider/path_provider.dart';

class FileProvider with ChangeNotifier {

  late CommonService _commonService;

  late AuthProvider? authProvider;

  FileProvider({this.authProvider}){
    getFlatFiles();
    getHierarchicalFiles();
  }

  List<File> _flatFiles = List.empty();

  FilesResponse? _hierarchicalFiles;

  FilesResponse? get hierarchicalFiles => _hierarchicalFiles;

  set hierarchicalFiles(FilesResponse? newResponse) {
    _hierarchicalFiles = newResponse;
    notifyListeners();
  }

  List<File> get flatFiles => _flatFiles;

  List<File> flatFilesByFilter({String discreteMimeType = ""}) {
    if (discreteMimeType != "")
      return _flatFiles
          .where((element) =>
              element.contentType?.startsWith(discreteMimeType) ?? false)
          .toList();
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
        Headers.contentLengthHeader: io.ContentType.json.mimeType
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

  Future uploadFile(
      {required String uploadUrl,
      required io.File fileToUpload,
      required ProgressCallback progressCallback}) async {
    try {
      var url = uploadUrl;
      var headers = {
        Headers.contentTypeHeader: io.ContentType.binary.mimeType,
        'x-ms-version': '2020-04-08',
        'x-ms-blob-type': 'BlockBlob'
      };
      await _commonService.put(
          url: url,
          headers: headers,
          body: fileToUpload,
          isFile: true,
          onSendProgress: progressCallback);
    } on Exception {
      print("Exception has occurred");
    }
  }

  downloadFile(String url, {required String filename}) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);

    String? dir = (await  .getExternalStorageDirectory())?.path;

    if(dir!=null) {
      List<List<int>> chunks = new List.empty(growable: true);
      int downloaded = 0;

      response.asStream().listen((http.StreamedResponse r) {
        r.stream.listen((List<int> chunk) {
          // Display percentage of completion
          debugPrint(
              'downloadPercentage: ${downloaded / (r.contentLength as num) *
                  100}');

          chunks.add(chunk);
          downloaded += chunk.length;
        }, onDone: () async {
          // Display percentage of completion
          debugPrint(
              'downloadPercentage: ${downloaded / (r.contentLength as num) *
                  100}');

          // Save the file
          io.File file = new io.File("$dir/$filename");
          final Uint8List bytes = Uint8List(r.contentLength!);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
          return;
        });
      });
    }
  }

  Future<String?> getUploadUri({required String fileName}) async {
    try {
      var url = API_ENDPOINT + "blob/upload";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: io.ContentType.json.mimeType
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
        Headers.contentLengthHeader: io.ContentType.json.mimeType
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

  Future getHierarchicalFiles({prefix = ""}) async {
    try {
      var url = API_ENDPOINT + "blob";
      var headers = {
        "Authorization": "Bearer ${this.authProvider?.accessToken}",
        Headers.contentLengthHeader: io.ContentType.json.mimeType
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
