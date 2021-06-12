import 'package:flutter/material.dart';
import 'package:open_locker_app/pages/LoginPage.dart';
import 'package:open_locker_app/pages/SignupPage.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider _authData = Provider.of<AuthProvider>(context);
    if(_authData.LoggedIn){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in bros")));
    }
    return LoginPage();
  }
}
