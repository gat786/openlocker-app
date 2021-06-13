import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_locker_app/constants.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/standard_response.dart';
import 'package:open_locker_app/services/common.service.dart';

class FileProvider with ChangeNotifier{
  late CommonService _commonService;

  List<File> _flatFiles = List.empty();

  List<File> get flatFiles => _flatFiles;

  set flatFiles(dynamic newFiles){
    _flatFiles = newFiles;
    notifyListeners();
  }

  Future getFlatFiles(String accessToken) async {
    var url = API_ENDPOINT + "blob/all";
    var headers = {"Authorization" : "Bearer $accessToken"};
    _commonService = await CommonService.getInstance();

    try{
    var response = await _commonService.get(url: url, headers: headers);
    if (response != null && response
        .toString()
        .isNotEmpty) {
      var standardResponse = StandardResponse.fromJson(
          Map.from(jsonDecode(response.toString())));
      if (standardResponse.success == true) {
        flatFiles = FlatFilesResponse
            .fromJson(standardResponse.data)
            .files;
      }
    }
  } on TokenExpiredException {
      throw TokenExpiredException();
    }
  }
}