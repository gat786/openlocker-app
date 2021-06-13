import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:provider/provider.dart';

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
        Navigator.popAndPushNamed(context, Routes.SignupPage);
      });
    }
    return Scaffold(
      body: PageView(
        children: [
          Center(
            child: Container(
              child: Text("Page 1"),
            ),
          ),

          Container(
            child: Text("Page 1"),
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

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1,),

        Container(
          height: 120,
          width: 120,
          child: Center(
              child: Text("GT".toUpperCase(),
                style: TextStyle(fontSize: 24),
              )
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor)
          ),
        ),

        SizedBox(height: 16,),
        Text("Username - ${authProvider.userData.userName}", style: Theme.of(context).textTheme.headline6,),

        SizedBox(height: 16,),
        Text("Email Address - ${authProvider.userData.emailAddress}", style: Theme.of(context).textTheme.headline6,),

        SizedBox(height: 16,),
        MaterialButton(onPressed: (){
          authProvider.logoutUser();
        }, child: Text("Log out"),)
      ],
    );
  }
}

