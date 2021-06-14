import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_locker_app/exceptions/token_expired.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/models/files_response.dart';
import 'package:open_locker_app/models/media_type.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/file_provider.dart';
import 'package:open_locker_app/widgets/selectable_chip.dart';
import 'package:provider/provider.dart';

import 'account_page.dart';
import 'drive_home_page.dart';

class DrivePage extends StatefulWidget {
  const DrivePage({Key? key}) : super(key: key);

  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  int currentlySelectedTab = 0;

  var pageViewController = PageController(
    initialPage: 0
  );

  void changeBottomNavSelectedItem(int selectedItem){
    setState((){
      currentlySelectedTab = selectedItem;
    });
    pageViewController.animateToPage(currentlySelectedTab, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if(!authProvider.isLoggedIn){
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, Routes.SignupPage);
      });
    }
    return Scaffold(
      body: PageView(
        children: [
          DriveHomePage(),

          Center(
            child: Container(
              child: Text("Page 1"),
            ),
          ),

          AccountPage()
        ],
        controller: pageViewController,
        onPageChanged: (selectedIndex) {
          setState((){
            currentlySelectedTab = selectedIndex;
          });
        },

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, ), label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file_sharp, ), label: "Files"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
        ],
        onTap: (index){
          changeBottomNavSelectedItem(index);
        },
        currentIndex: currentlySelectedTab,
      ),
    );
  }
}


