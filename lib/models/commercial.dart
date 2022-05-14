import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Commercial {
  String? id;

  String? type;

  double? area;

  String? documentType;

  int? floor;
  double? commercialArea;

  // ####

  String? city;
  String? district;

  String? quarter;
  String? alley;
  List<double>? location;
  int? price;

  // ####

  Commercial({
    this.id,
    this.type,
    this.area,
    this.documentType,
    this.floor,
    this.commercialArea,
    //
    this.city,
    this.district,
    this.quarter,
    this.alley,
    this.location,
    this.price,
  });

  factory Commercial.fromJson(Map<String, dynamic> json) =>
      _$CommercialFromJson(json);
  Map<String, dynamic> toJson() => _$CommercialToJson(this);
}
