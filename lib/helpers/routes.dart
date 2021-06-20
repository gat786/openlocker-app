import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_locker_app/pages/drive_page.dart';
import 'package:open_locker_app/pages/preview_pages/image.dart';
import 'package:open_locker_app/pages/login_page.dart';
import 'package:open_locker_app/pages/preview_pages/music.dart';
import 'package:open_locker_app/pages/signup_page.dart';

class Routes{
  static const String LoginPage = "/login";
  static const String SignupPage = "/register";
  static const String DrivePage = "/drive";
  static const String ImageViewer = "/image";
  static const String MusicPlayer = "/music";
}

class RoutesGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final dynamic args = settings.arguments;

    switch(settings.name){
      case Routes.LoginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.SignupPage:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case Routes.ImageViewer:
        return MaterialPageRoute(builder: (_) => ImagePreview(imageUrl: (args as Map<String,String>)['imageUrl']!));
      case Routes.MusicPlayer:
        return MaterialPageRoute(builder: (_) => MusicPreviewPage(musicUrl: (args as Map<String,String>)['musicUrl']!));
      default:
        return MaterialPageRoute(builder: (_) => DrivePage());
    }
  }
}