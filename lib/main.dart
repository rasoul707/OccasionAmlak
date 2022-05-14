import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:dio/dio.dart';
import 'api/user.dart';

import 'data/strings.dart';
import 'data/theme.dart';

import 'screens/splash.dart';
import 'screens/auth.dart';
import 'screens/dash.dart';
import 'screens/new.dart';

void main() {
  debugPaintSizeEnabled = false;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: ThemeModeManager(),
      placeholderWidget: const SplashScreen(loaded: false),
      builder: (ThemeMode themeMode) {
        return MaterialApp(
            title: appTitle,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: const RootApp(),
            localizationsDelegates: const [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
            ],
            locale: const Locale("fa", "IR"));
      },
    );
  }
}

// ##################
// ##################
// ##################

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isLoaded = false;
  bool mainContentLoad = false;
  late String ggg = "5555";

  void toggleAuthScreen(bool oc) {
    setState(() {
      mainContentLoad = oc;
    });
  }

  void toggleSplashScreen(bool oc) {
    setState(() {
      isLoaded = oc;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoaded = true;
    mainContentLoad = true;
    // Future.delayed(
    //   const Duration(seconds: 2),
    //   () {
    //     toggleSplashScreen(true);
    //     Future.delayed(
    //       const Duration(seconds: 3),
    //       () {
    //         toggleAuthScreen(false);
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<Task>>(
    //   future: RestClient(Dio()).getTasks(),
    //   builder: (context, snapshot) {
    //     // if (snapshot.hasData) {
    //     //   return Text(snapshot.data!.elementAt(3).name!);
    //     // } else if (snapshot.hasError) {
    //     //   return Text('${snapshot.error}');
    //     // }
    //     return const SplashScreen();
    //   },
    // );

    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (!mainContentLoad) {
              setState(() {
                mainContentLoad = true;
              });
              return false;
            }
            return true;
          },
          child: isLoaded
              ? mainContentLoad
                  ? Text(ggg.toString())
                  : const AuthContent()
              : const SplashScreen(),
        )
      ],
    );
  }
}
