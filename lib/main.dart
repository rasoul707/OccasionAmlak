import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:dio/dio.dart';

import 'data/strings.dart';

import 'screens/splash.dart';
import 'screens/auth.dart';
import 'screens/dash.dart';

import 'widgets/theme.dart';

import 'api/main.dart';
import 'helpers/user.dart';

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
  bool _reload = false;
  reload() {
    setState(() {
      _reload = !_reload;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // check token valid
  Future<bool> isValid() async {
    await Future.delayed(const Duration(seconds: 2));
    String? token = await getAuthToken();
    if (token is String) {
      dynamic result =
          await API(Dio(BaseOptions(headers: {"Authorization": token})))
              .validate()
              .catchError((Object obj) => false);
      if (result != false) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isValid(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!) {
            case true:
              return DashContent(reload);
            case false:
              return AuthContent(reload);
          }
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return const SplashScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
