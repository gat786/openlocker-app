import 'package:flutter/material.dart';
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
  var isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return Container(
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: userNameController,
                      validator: validateUsername,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: validatePassword,
                      obscureText: isTextVisible,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              this.setState(() {
                                isTextVisible = !isTextVisible;
                              });
                            },
                            icon: Icon(isTextVisible
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye),
                          )),
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                        onPressed: () {
                          print("Validating");
                          if (_loginFormKey.currentState!.validate()) {
                            // validation successful
                            provider.loginUser(userNameController.text,passwordController.text);

                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Login",
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
