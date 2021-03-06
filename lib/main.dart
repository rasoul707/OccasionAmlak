import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'api/main.dart';
import 'api/services.dart';
import 'data/strings.dart';

import 'models/response.dart';
import 'screens/splash.dart';
import 'screens/auth.dart';
import 'screens/dash.dart';

import 'helpers/theme.dart';

import 'helpers/user.dart';

void main() {
  debugPaintSizeEnabled = false;
  // WidgetsFlutterBinding.ensureInitialized();

  // FlipperClient flipperClient = FlipperClient.getDefault();
  // flipperClient.addPlugin(FlipperNetworkPlugin());
  // flipperClient.addPlugin(FlipperSharedPreferencesPlugin());
  // // flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin());
  // // flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
  // flipperClient.start();
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
            Locale("fa", "IR"), // rtl
          ],
          locale: const Locale("fa", "IR"),
        );
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
  @override
  void initState() {
    super.initState();
    authentication();
  }

  // check token valid
  Future<void> authentication() async {
    bool showDashboard = false;
    bool hasUser = await hasUserData();

    API api = await apiService();
    ApiResponse _result = await api.validate().catchError(serviceError);

    // okay
    if (_result.code! == "jwt_auth_valid_token") showDashboard = true;

    // finish
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: (showDashboard && hasUser)
            ? const DashContent()
            : const AuthContent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
