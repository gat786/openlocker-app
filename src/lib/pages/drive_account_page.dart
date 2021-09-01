import 'package:flutter/material.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:provider/provider.dart';

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
              child: Text("${authProvider.userData.userName?.substring(0, 2)}".toUpperCase(),
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
