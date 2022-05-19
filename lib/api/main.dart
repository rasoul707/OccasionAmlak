import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/casefile.dart';
import '../models/user.dart';

part 'main.g.dart';

@RestApi(baseUrl: "https://iranocc.com/wp-json/")
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;

  @POST("jwt-auth/v1/token")
  Future<LoginRes> login(@Body() LoginReq loginReq);

  @POST("jwt-auth/v1/token/validate")
  Future<String> validate();

  @GET("rapp/v1/getMe")
  Future<User> getMe();

  @POST("rapp/v1/addFile")
  Future<int> addFile(@Body() CaseFile data);

  @MultiPart()
  @POST("wp/v2/media/")
  Future<dynamic> upload(@Part(name: 'file') File image);
}
