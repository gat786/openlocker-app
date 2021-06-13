import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:open_locker_app/widgets/Loader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/flutter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  MyApp({required final this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) => LoadingProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(children: [
          MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) =>
                RoutesGenerator.generateRoute(settings),
            initialRoute: Routes.SignupPage,
            theme: theme,
          ),
          LoadingOverlay()
        ]),
      ),
    );
  }
}
