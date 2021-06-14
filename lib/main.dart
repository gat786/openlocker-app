import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:open_locker_app/widgets/Loader.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<LoadingProvider>(
      create: (_) => LoadingProvider(),
    ),
    ChangeNotifierProxyProvider<AuthProvider, FileProvider>(
      create: (_) => FileProvider(),
      update: (_, updatedAuthProvider, currentFileProvider) =>
          FileProvider(authProvider: updatedAuthProvider),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(children: [
        MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) =>
              RoutesGenerator.generateRoute(settings),
          initialRoute: Routes.SignupPage,
          theme: ThemeData(primaryColor: Color.fromRGBO(0, 26, 255, 1)),
        ),
        LoadingOverlay()
      ]),
    );
  }
}
