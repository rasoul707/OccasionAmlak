import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../api/services.dart';
import '../data/strings.dart';
import '../models/user.dart';

import '../widgets/button.dart';
import '../helpers/user.dart';
import '../widgets/snackbar.dart';

import 'dash.dart';

class AuthContent extends StatefulWidget {
  const AuthContent({Key? key}) : super(key: key);

  @override
  _AuthContentState createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  bool disabled = true;

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

  final FocusNode usernameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  submit() async {
    if (disabled) return;
    setState(() {
      disabled = true;
    });
    final String username = usernameController.text;
    final String password = passwordController.text;
    final LoginReq req = LoginReq(username: username, password: password);

    // error action
    ErrorAction _err = ErrorAction(
      response: (r) {
        OccSnackBar.error(context, r.data['code']);
      },
      connection: () {
        OccSnackBar.error(context, internetConnectionErrorLabel);
      },
    );

    LoginRes _result = await Services.login(req, _err);

    // okay
    if (_result.token != null) {
      OccSnackBar.success(context, loginSuccessText);
      await setAuthToken(_result.token!);
      await saveUserData(_result.user!);
      await Future.delayed(const Duration(milliseconds: 900));
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const DashContent(),
        ),
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
      body: SafeArea(
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
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  appTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: Text(
                  loginFormTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  focusNode: usernameNode,
                  controller: usernameController,
                  enabled: !disabled,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(passwordNode);
                  },
                  textDirection: TextDirection.ltr,
                  enableSuggestions: true,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: usernameLabel),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  focusNode: passwordNode,
                  controller: passwordController,
                  enabled: !disabled,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: submit,
                  textDirection: TextDirection.ltr,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(labelText: passwordLabel),
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
    );
  }
}
