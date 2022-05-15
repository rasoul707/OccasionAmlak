import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user.dart';

part 'main.g.dart';

@RestApi(baseUrl: "https://iranocc.com/wp-json/")
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;

  @POST("jwt-auth/v1/token")
  Future<LoginRes> login(@Body() LoginReq loginReq);

  @POST("jwt-auth/v1/token/validate")
  Future<String> validate();

  @GET("method/getMe")
  Future<User> getMe();

  @POST("method/addFile")
  Future<String> addFile();
}
