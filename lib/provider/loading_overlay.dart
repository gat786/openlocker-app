import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LoadingProvider with ChangeNotifier{
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool newValue){
    _isLoading = newValue;
    notifyListeners();
  }
}