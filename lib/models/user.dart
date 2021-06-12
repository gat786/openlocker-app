import 'package:flutter/cupertino.dart';

class User {
  String? userName, emailAddress, refreshToken;

  User({this.userName, this.emailAddress, this.refreshToken});
}

class UserLogin {
  String? userName, password;

  UserLogin({this.userName, this.password});
}



class UserSignup {
  String? userName, emailAddress, password;

  UserSignup({this.userName, this.emailAddress, this.password});
}
