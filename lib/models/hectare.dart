import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Hectare {
  String? id;

  String? usageStatus;
  String? tissueStatus;

  double? area;

  String? documentType;

  // ####

  String? city;
  String? district;

  String? quarter;
  String? alley;
  List<double>? location;
  int? price;

  // ####

  Hectare({
    this.id,
    this.usageStatus,
    this.tissueStatus,
    this.area,
    this.documentType,
    //
    this.city,
    this.district,
    this.quarter,
    this.alley,
    this.location,
    this.price,
  });

  factory Hectare.fromJson(Map<String, dynamic> json) =>
      _$HectareFromJson(json);
  Map<String, dynamic> toJson() => _$HectareToJson(this);
}
