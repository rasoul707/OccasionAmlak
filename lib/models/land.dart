import 'package:json_annotation/json_annotation.dart';

part 'land.g.dart';

@JsonSerializable()
class Land {
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

  Land({
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

  factory Land.fromJson(Map<String, dynamic> json) => _$LandFromJson(json);
  Map<String, dynamic> toJson() => _$LandToJson(this);
}
