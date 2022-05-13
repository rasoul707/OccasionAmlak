import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/occbutton.dart';

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
                        image: AssetImage("assets/images/default_avatar.png"),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    'رسول احمدی فر',
                    style: TextStyle(
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
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: const [
                              Text(
                                "در انتظار تایید",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "3",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: textFieldBgColor,
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: const [
                              Text(
                                "فایل های تایید شده",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "24",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: textFieldBgColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: OccButton(onPressed: () {}, label: "ثبت فایل جدید"),
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
