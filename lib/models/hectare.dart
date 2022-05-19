import 'package:json_annotation/json_annotation.dart';

part 'hectare.g.dart';

@JsonSerializable()
class Hectare {
  String? usageStatus;
  String? tissueStatus;
  double? area;
  String? documentType;

  Hectare({
    this.usageStatus,
    this.tissueStatus,
    this.area,
    this.documentType,
  });

  factory Hectare.fromJson(Map<String, dynamic> json) =>
      _$HectareFromJson(json);
  Map<String, dynamic> toJson() => _$HectareToJson(this);
}
