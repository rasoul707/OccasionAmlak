import 'package:flutter/material.dart';
import 'package:occasionapp/helpers/user.dart';
import '../models/user.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/occButton.dart';
import '../widgets/occCard.dart';

class DashContent extends StatefulWidget {
  const DashContent({Key? key}) : super(key: key);

  @override
  _DashContentState createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: hintColor,
                        child: Padding(
                          padding: EdgeInsets.all(8), // Border radius
                          child: ClipOval(
                            child: Image(
                              image: AssetImage(
                                  "assets/images/default_avatar.png"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Text(
                          snapshot.data!.displayName!,
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
                              // sub: snapshot.data!.pending!.toString(),
                            ),
                          ),
                          Expanded(
                            child: OccCard(
                              head: confirmedFilesLabel,
                              // sub: snapshot.data!.confirmed!.toString(),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: OccButton(
                          onPressed: () {},
                          label: newFileButton,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error Dash");
        } else {
          return Text("Loading Dash");
        }
      },
      initialData: User(),
    );
  }
}
