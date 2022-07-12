import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class ImageData {
  List<dynamic>? thumbnail;
  List<dynamic>? medium;
  List<dynamic>? large;
  List<dynamic>? file;

  ImageData({
    this.thumbnail,
    this.medium,
    this.large,
    this.file,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}
