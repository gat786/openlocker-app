import 'package:flutter/material.dart';
import 'package:open_locker_app/helpers/routes.dart';
import 'package:open_locker_app/helpers/validators.dart';
import 'package:open_locker_app/provider/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _loginFormKey = new GlobalKey<FormState>();
  var passwordFieldHidden = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Material(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                        color: Theme.of(context).primaryColor,
                        fontSize: 32.0),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: userNameController,
                          validator: validateUsername,
                          decoration: InputDecoration(hintText: "Username"),
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
                          onTap: () {
                            print("Validating");
                            if (_loginFormKey.currentState!.validate()) {
                              // validation successful
                              provider.loginUser(
                                  userName: userNameController.text,
                                  password: passwordController.text);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text("Login",
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
                            Text("Dont have an account?"),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, Routes.SignupPage);
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
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
