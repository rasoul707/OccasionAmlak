import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key, this.loaded = true}) : super(key: key);

  final bool loaded;

  @override
  Widget build(BuildContext context) {
    if (!loaded) return Container();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: brandColorGradient,
            begin: FractionalOffset(1.0, 0.0),
            end: FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Column(
                  children: const [
                    Image(
                      image: AssetImage("assets/images/logo_black.png"),
                      width: 270,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      appTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      appDesc,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Text(
                    appVer,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
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
