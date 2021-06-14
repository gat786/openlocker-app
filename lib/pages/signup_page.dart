import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/helpers/validators.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:open_locker_app/provider/loading_overlay.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailAddressController = new TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _signupFormKey = new GlobalKey<FormState>();
  var passwordFieldHidden = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    LoadingProvider loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    getData() async {
      if(authProvider.userData.refreshToken != null && authProvider.userData.refreshToken != ""){
        loadingProvider.isLoading = true;
        await authProvider.getAccessToken();
        loadingProvider.isLoading = false;
      }
      if(authProvider.isLoggedIn){
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushNamed(context, Routes.DrivePage);
        });
      }
    }

    getData();

    return Scaffold(
      body: Material(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/icons/logo.png"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OPENLOCKER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: 32.0),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: userNameController,
                          validator: validateUsername,
                          decoration: InputDecoration(
                              hintText: "UserName"
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          validator: validateEmail,
                          controller: emailAddressController,
                          decoration: InputDecoration(
                              hintText: "Email Address"
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: validatePassword,
                          obscureText: passwordFieldHidden,
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  this.setState(() {
                                    passwordFieldHidden = !passwordFieldHidden;
                                  });
                                },
                                icon: Icon(passwordFieldHidden
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () async {
                            print("Validating");
                            if (_signupFormKey.currentState!.validate()) {
                              // validation successful
                              loadingProvider.isLoading = true;
                              await authProvider.signupUser(
                                  userName: userNameController.text,
                                  emailAddress: emailAddressController.text,
                                  password: passwordController.text);
                              loadingProvider.isLoading = false;
                              if(authProvider.isLoggedIn){
                                Navigator.popAndPushNamed(context, Routes.DrivePage);
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text("Register",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an Account?"),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, Routes.LoginPage);
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
