import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

Future<User> saveUserData(User user) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  localStorage.setInt("id", user.id!);
  localStorage.setString("firstName", user.firstName!);
  localStorage.setString("lastName", user.lastName!);
  localStorage.setString("email", user.email!);
  localStorage.setString("niceName", user.niceName!);
  localStorage.setString("displayName", user.displayName!);
  localStorage.setString("username", user.username!);
  localStorage.setInt("confirmed", user.confirmed!);
  localStorage.setInt("pending", user.pending!);

  return user;
}

Future<User> readUserData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  return User(
    id: localStorage.getInt("id"),
    firstName: localStorage.getString("firstName"),
    lastName: localStorage.getString("lastName"),
    email: localStorage.getString("email"),
    niceName: localStorage.getString("niceName"),
    displayName: localStorage.getString("displayName"),
    username: localStorage.getString("username"),
    confirmed: localStorage.getInt("confirmed"),
    pending: localStorage.getInt("pending"),
  );
}

Future<bool> removeUserData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  localStorage.remove("id");
  localStorage.remove("firstName");
  localStorage.remove("lastName");
  localStorage.remove("email");
  localStorage.remove("niceName");
  localStorage.remove("displayName");
  localStorage.remove("username");
  localStorage.remove("confirmed");
  localStorage.remove("pending");

  return true;
}

Future<bool> hasUserData() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  return localStorage.getInt("id") != null;
}

//
//

Future<String> setAuthToken(String token) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString("authToken", token);
  return token;
}

Future<String> getAuthToken() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String? m = localStorage.getString("authToken");
  if (m is String) return 'Bearer ' + m;
  return '';
}

Future<bool> removeAuthToken() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.remove("authToken");
  return true;
}
