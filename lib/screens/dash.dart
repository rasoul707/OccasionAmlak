import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:occasionapp/screens/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';

import '../api/services.dart';
import '../data/colors.dart';
import '../data/strings.dart';

import '../widgets/button.dart';
import '../widgets/card.dart';

import '../models/user.dart';
import '../helpers/user.dart';

import '../screens/new.dart';
import '../widgets/snackbar.dart';

class DashContent extends StatefulWidget {
  const DashContent({Key? key}) : super(key: key);

  @override
  _DashContentState createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  bool _reload = false;
  bool disabled = false;
  reload() {
    setState(() {
      _reload = !_reload;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      // _refreshIndicatorKey.currentState?.show();
      updateUserData(conError: true);
    });
  }

  addNewFile() async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const NewFile(),
      ),
    ).then((_) => updateUserData(conError: false));
  }

  logout() async {
    final bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(modalLogoutTitle),
          content: const Text(modalLogoutSubTitle),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(logoutDialogButtonNo),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(logoutDialogButtonYes),
            ),
          ],
        );
      },
    );
    if (result is bool && result) {
      setState(() {
        disabled = true;
      });
      await Future.delayed(const Duration(milliseconds: 900));
      await removeAuthToken();
      await removeUserData();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const AuthContent(),
        ),
      );
    }
  }

  // update user data
  Future<void> updateUserData({bool? conError}) async {
    // error action
    ErrorAction _err = ErrorAction(
      response: (r) {
        OccSnackBar.error(context, r.data['code']);
      },
      connection: () {
        if (conError is bool && conError == false) {
          //
        } else {
          OccSnackBar.error(context, internetConnectionErrorLabel);
        }
      },
    );

    User _result = await Services.getMe(_err);

    // okay
    if (_result.id != null) {
      await saveUserData(_result);
      reload();
    }
  }

  static const defaultAvatar = 'assets/images/default_avatar.png';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final User user = snapshot.data!;
          final _height = MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom;

          final displayName =
              user.displayName != null ? user.displayName.toString() : "";

          final pendingCount =
              user.pending != null ? user.pending.toString() : "";

          final confirmedCount =
              user.confirmed != null ? user.confirmed.toString() : "";

          String avatarUrl = '';
          if (user.email != null) {
            final gravatar = Gravatar(user.email!);
            avatarUrl = gravatar.imageUrl();
          }

          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: updateUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: _height,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            ClipOval(
                              child: Container(
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      8,
                                    ), // Border radius
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: defaultAvatar,
                                        image: avatarUrl,
                                        fit: BoxFit.fill,
                                        placeholderFit: BoxFit.fill,
                                        fadeInDuration:
                                            const Duration(milliseconds: 300),
                                        fadeOutDuration:
                                            const Duration(milliseconds: 300),
                                        imageErrorBuilder: (c, o, s) {
                                          return const Scaffold();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                width: 100,
                                height: 100,
                                color: hintColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Text(
                                displayName,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: OccCard(
                                    head: pendingFilesLabel,
                                    sub: pendingCount,
                                  ),
                                ),
                                Expanded(
                                  child: OccCard(
                                    head: confirmedFilesLabel,
                                    sub: confirmedCount,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: OccButton(
                                onPressed: addNewFile,
                                label: newFileButton,
                                enabled: !disabled,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: OccButton(
                                onPressed: logout,
                                label: logoutButton,
                                type: 'cancel',
                                enabled: !disabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("Error Dash");
        } else {
          return const Scaffold(backgroundColor: bgColor);
        }
      },
      initialData: null,
    );
  }
}
