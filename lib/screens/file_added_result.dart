import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/button.dart';

class FileAddedResult extends StatelessWidget {
  const FileAddedResult(
    this.success, {
    Key? key,
  }) : super(key: key);

  final bool success;

  @override
  Widget build(BuildContext context) {
    String imgSrc = "error";
    String title = fileAddedErrorTitle;
    String subTitle = fileAddedErrorSubTitle;

    if (success) {
      imgSrc = "success";
      title = fileAddedSuccessTitle;
      subTitle = fileAddedSuccessSubTitle;
    }

    backToHome() {
      Navigator.popUntil(
        context,
        (Route<dynamic> route) => route.isFirst,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        backToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Image(
                    image: AssetImage("assets/images/" + imgSrc + ".png"),
                    width: 235,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      subTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: OccButton(
                      onPressed: backToHome,
                      label: back2HomeButtonLabel,
                      type: 'cancel',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
