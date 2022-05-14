import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// class services {
//   SharedPreferences localStorage;

//   static Future init() async {
//     localStorage = await SharedPreferences.getInstance();
//   }

//   API call() => api;
// }

// final pref = SharedPreferences.getInstance();

// Future<API?> sss() async {
//   late API api;

  // API(
  //   Dio(
  //     BaseOptions(
  //       contentType: 'application/json',
  //       headers: {
  //         "Aouthorization": pref.getString("auth_token"),
  //       },
  //     ),
  //   ),
  // );
// }




// Future<String?> getAuthToken() async {
  
//   await Future.delayed(const Duration(milliseconds: 500));
//   return pref.getString("auth_token");
// }

// Future<bool?> setAuthToken(String value) async {
//   final pref = await SharedPreferences.getInstance();
//   return pref.setString("auth_token", value);
// }
