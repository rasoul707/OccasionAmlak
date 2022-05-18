import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';

import '../api/services.dart';
import '../data/colors.dart';
import '../data/strings.dart';

import '../widgets/occButton.dart';
import '../widgets/occCard.dart';

import '../api/main.dart';
import '../models/user.dart';
import '../helpers/user.dart';

import '../screens/new.dart';
import '../widgets/occsnackbar.dart';

class DashContent extends StatefulWidget {
  const DashContent({Key? key}) : super(key: key);

  @override
  _DashContentState createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  bool _reload = false;
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
          OccSnackBar.error(context, "دستگاه به اینترنت متصل نیست!");
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final User user = snapshot.data!;

          return Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: updateUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            const CircleAvatar(
                              radius: 55,
                              backgroundColor: hintColor,
                              child: Padding(
                                padding: EdgeInsets.all(8), // Border radius
                                child: ClipOval(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/default_avatar.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Text(
                                user.displayName != null
                                    ? user.displayName.toString()
                                    : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: OccCard(
                                    head: pendingFilesLabel,
                                    sub: user.pending != null
                                        ? user.pending.toString()
                                        : "",
                                  ),
                                ),
                                Expanded(
                                  child: OccCard(
                                    head: confirmedFilesLabel,
                                    sub: user.confirmed != null
                                        ? user.confirmed.toString()
                                        : "",
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: OccButton(
                                onPressed: addNewFile,
                                label: newFileButton,
                              ),
                            ),
                            const Spacer(),
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
