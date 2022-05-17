import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:occasionapp/api/services.dart';
import 'package:page_transition/page_transition.dart';

import '../data/colors.dart';
import '../data/strings.dart';

import '../widgets/occButton.dart';

import '../api/main.dart';
import '../models/user.dart';
import '../helpers/user.dart';
import '../widgets/occsnackbar.dart';
import 'dash.dart';

class AuthContent extends StatefulWidget {
  const AuthContent({Key? key}) : super(key: key);

  @override
  _AuthContentState createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    disabled = false;

    removeUsageData();
  }

  void removeUsageData() async {
    await removeAuthToken();
    await removeUserData();
  }

  final FocusNode passwordNode = FocusNode();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  submit() async {
    if (disabled) return;
    setState(() {
      disabled = true;
    });
    String username = usernameController.text;
    String password = passwordController.text;
    final LoginReq req = LoginReq(username: username, password: password);

    // error action
    ErrorAction _err = ErrorAction(
      response: (r) {
        OccSnackBar.error(context, r.data['code']);
      },
      connection: () {
        OccSnackBar.error(context, "دستگاه به اینترنت متصل نیست!");
      },
    );

    LoginRes _result = await Services.login(req, _err);

    // okay
    if (_result.token != null) {
      await setAuthToken(_result.token!);
      await saveUserData(_result.user!);
      Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            duration: const Duration(seconds: 1),
            alignment: Alignment.center,
            child: const DashContent()),
      );
    }

    // finish
    setState(() {
      disabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 220,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    appTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 25),
                  child: Text(
                    loginFormTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: usernameController,
                    enabled: !disabled,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordNode);
                    },
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    enableSuggestions: true,
                    autocorrect: false,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      labelText: usernameLabel,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      fillColor: textFieldBgColor,
                      focusColor: textColor,
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: passwordController,
                    enabled: !disabled,
                    textInputAction: TextInputAction.done,
                    focusNode: passwordNode,
                    onEditingComplete: submit,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      labelText: passwordLabel,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      fillColor: textFieldBgColor,
                      focusColor: textColor,
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: OccButton(
                    onPressed: submit,
                    label: loginButtonLabel,
                    loading: disabled,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
