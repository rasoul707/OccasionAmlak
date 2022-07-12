import 'package:json_annotation/json_annotation.dart';
import './casefile.dart';
import './user.dart';

part 'response.g.dart';

@JsonSerializable()
class ApiResponse {
  bool? ok;
  int? id;
  String? code;
  String? message;
  CaseFile? file;
  List<CaseFile>? files;
  User? user;
  String? token;

  ApiResponse({
    this.id,
    this.ok,
    this.code,
    this.message,
    this.file,
    this.files,
    this.user,
    this.token,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
