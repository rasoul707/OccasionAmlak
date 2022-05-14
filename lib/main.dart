import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'package:dio/dio.dart';

import 'api/main.dart';
import 'data/strings.dart';

import 'widgets/theme.dart';

import 'screens/splash.dart';
import 'screens/auth.dart';
import 'screens/dash.dart';
import 'screens/new.dart';

import 'models/user.dart';

import 'api/services.dart';

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
  bool isValid = false;

  // void toggleAuthScreen(bool oc) {
  //   setState(() {
  //     isValid = oc;
  //   });
  // }

  // void toggleSplashScreen(bool oc) {
  //   setState(() {
  //     isLoaded = oc;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    isLoaded = false;
    isValid = false;
  }

  Future<Widget> validation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString("authToken");
    Widget? Comp = null;
    if (token is String) {
      String result =
          await API(Dio(BaseOptions(headers: {"Authorization": token})))
              .validate()
              .catchError(
        (Object obj) {
          switch (obj.runtimeType) {
            case DioError:
              final res = (obj as DioError).response;
              print(res!.data);
              break;
            default:
              break;
          }
          return "error";
        },
      );

      if (result == 'error') {
        localStorage.remove("authToken");
        localStorage.remove("displayName");
        Comp = const AuthContent();
      } else {
        Comp = const DashContent();
      }
    } else {
      Comp = const AuthContent();
    }

    return Comp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: validation(),
      builder: (context, snapshot) {
        return snapshot.data!;
      },
      initialData: const SplashScreen(),
    );

    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            if (!isValid) {
              setState(() {
                isValid = true;
              });
              return false;
            }
            return true;
          },
          child: isLoaded
              ? isValid
                  ? Text("ggg".toString())
                  : const AuthContent()
              : const SplashScreen(),
        )
      ],
    );
  }
}
