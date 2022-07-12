import 'package:dio/dio.dart';
import '../helpers/user.dart';
import '../models/response.dart';

import 'main.dart';

ApiResponse serviceError(Object obj) {
  if (obj.runtimeType == DioError) {
    obj = (obj as DioError);
    switch (obj.type) {
      case DioErrorType.response:
        return ApiResponse.fromJson(obj.response?.data);
      case DioErrorType.connectTimeout:
        return ApiResponse(ok: false, code: "ConnectTimeout");
      case DioErrorType.receiveTimeout:
        return ApiResponse(ok: false, code: "ReceiveTimeout");
      case DioErrorType.sendTimeout:
        return ApiResponse(ok: false, code: "SendTimeout");
      case DioErrorType.other:
        return ApiResponse(ok: false, code: "Other");
      case DioErrorType.cancel:
        return ApiResponse(ok: false, code: "Cancel");
      default:
        return ApiResponse(ok: false, code: "UnknownDioError");
    }
  }
  return ApiResponse(ok: false, code: "UnknownError");
}

Future<Dio> dioWithToken() async {
  String token = await getAuthToken();
  return Dio(BaseOptions(headers: {"Authorization": token}));
}

Future<Dio> dioFree() async {
  return Dio();
}

Future<API> apiService({bool auth = true}) async {
  return API(auth ? await dioWithToken() : await dioFree());
}
