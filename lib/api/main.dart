import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/casefile.dart';
import '../models/response.dart';
import '../models/user.dart';

part 'main.g.dart';

@RestApi(baseUrl: "https://iranocc.com/wp-json/")
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;

  @POST("jwt-auth/v1/token")
  Future<ApiResponse> login(@Body() LoginReq loginReq);

  @POST("jwt-auth/v1/token/validate")
  Future<ApiResponse> validate();

  @GET("rapp/v1/getMe")
  Future<ApiResponse> getMe();

  @POST("rapp/v1/addFile")
  Future<dynamic> addFile(@Body() CaseFile data);

  @GET("rapp/v1/getFile/{id}")
  Future<ApiResponse> getFile(@Path("id") int id);

  @GET("rapp/v1/searchFile")
  Future<ApiResponse> searchFile(
    @Query("type") String type,
    @Query("price") String price,
    @Query("district") String district,
    @Query("area") String area,
    @Query("buildingArea") String buildingArea,
    @Query("canBarter") int canBarter,
  );

  @MultiPart()
  @POST("wp/v2/media/")
  Future<ApiResponse> upload(@Part(name: 'file') File image);
}
