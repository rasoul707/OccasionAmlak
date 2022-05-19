import 'package:occasionapp/models/apartment.dart';
import 'package:occasionapp/models/commercial.dart';
import 'package:occasionapp/models/hectare.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/user.dart';
import '../models/file.dart';
import '../models/land.dart';
import '../models/user.dart';
import '../models/villa.dart';
import '../widgets/snackbar.dart';
import 'main.dart';

class Services {
  static dynamic errorHandler(Object obj, err, ty) {
    //
    if (obj.runtimeType == DioError) {
      obj = (obj as DioError);
      switch (obj.type) {
        case DioErrorType.response:
          if (err is ErrorAction && err.response is void Function(dynamic)) {
            err.response!(obj.response!);
          }
          break;
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.other:
          if (err is ErrorAction && err.connection is void Function()) {
            err.connection!();
          }
          break;
        case DioErrorType.cancel:
          if (err is ErrorAction && err.cancel is void Function()) {
            err.cancel!();
          }
          break;
        default:
          break;
      }
    } else {
      err.connection!();
    }
    return ty;
  }

  static Future<Dio> dioWithToken() async {
    String token = await getAuthToken();
    return Dio(BaseOptions(headers: {"Authorization": token}));
  }

  ///************************************************/
  //
  //
  static Future<String> authentication(ErrorAction e) async =>
      await API(await dioWithToken())
          .validate()
          .catchError((o) => errorHandler(o, e, ''));

  static Future<LoginRes> login(LoginReq m, ErrorAction e) async =>
      await API(Dio())
          .login(m)
          .catchError((o) => errorHandler(o, e, LoginRes()));

  static Future<User> getMe(ErrorAction e) async =>
      await API(await dioWithToken())
          .getMe()
          .catchError((o) => errorHandler(o, e, User()));

  static Future<int> addFile(File m, ErrorAction e) async =>
      await API(await dioWithToken())
          .addFile(m)
          .catchError((o) => errorHandler(o, e, 0));

  //
  //
  ///************************************************/
}

class ErrorAction {
  void Function(dynamic res)? response;
  void Function()? connection;
  void Function()? cancel;

  ErrorAction({this.response, this.connection, this.cancel});
}
