import 'package:occasionapp/models/commercial.dart';
import 'package:occasionapp/models/file.dart';
import 'package:occasionapp/models/hectare.dart';
import 'package:occasionapp/models/land.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user.dart';
import '../models/villa.dart';
import '../models/apartment.dart';

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
  Future<int> addFile(@Body() File data);
}
