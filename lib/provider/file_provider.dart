import 'package:flutter/cupertino.dart';

class FileProvider with ChangeNotifier{
  dynamic _files = {};

  dynamic get files => _files;

  set files(dynamic newFiles){
    _files = newFiles;
    notifyListeners();
  }
}