import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';

part 'user.g.dart';

@RestApi(baseUrl: "https://iranocc.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/auth")
  Future<User> getUser();

  @POST("/login")
  @FormUrlEncoded()
  Future<User> loginUser(
    @Field("username") username,
    @Field("password") password,
  );
}
