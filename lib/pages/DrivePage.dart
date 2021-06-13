import 'package:flutter/material.dart';

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

          Container(
            child: Text("Page 1"),
          )
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
