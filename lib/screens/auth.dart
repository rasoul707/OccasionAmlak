import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';

import '../widgets/occbutton.dart';

class AuthContent extends StatefulWidget {
  const AuthContent({Key? key}) : super(key: key);

  @override
  _AuthContentState createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  @override
  void initState() {
    super.initState();
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
                  image: const AssetImage("assets/images/logo.png"),
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
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      // FocusScope.of(context).requestFocus(focusF2);
                    },
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    enableSuggestions: true,
                    autocorrect: false,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      labelText: "نام کاربری",
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
                    textInputAction: TextInputAction.done,
                    // keyboardType: ,
                    onEditingComplete: () {
                      // FocusScope.of(context).requestFocus(focusF2);
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      labelText: "رمز اکانت",
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
                    onPressed: () {},
                    label: "ورود به سامانه",
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
