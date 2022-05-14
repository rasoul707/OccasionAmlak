import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  String? id;
  String? name;
  String? avatar;
  int? confirmed;
  int? pending;

  User({this.id, this.name, this.avatar, this.confirmed, this.pending});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
