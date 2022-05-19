import 'package:json_annotation/json_annotation.dart';

part 'land.g.dart';

@JsonSerializable()
class Land {
  String? usageStatus;
  String? tissueStatus;
  double? area;
  String? documentType;

  Land({
    this.usageStatus,
    this.tissueStatus,
    this.area,
    this.documentType,
  });

  factory Land.fromJson(Map<String, dynamic> json) => _$LandFromJson(json);
  Map<String, dynamic> toJson() => _$LandToJson(this);
}
