import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Villa {
  String? id;

  String? type;

  double? landArea;
  double? buildingArea;

  int? constructionYear;
  String? documentType;

  int? roomsCount;
  int? mastersCount;

  // ####

  String? city;
  String? district;

  String? quarter;
  String? alley;
  List<double>? location;
  int? price;

  // ####

  Villa({
    this.id,
    this.type,
    this.landArea,
    this.buildingArea,
    this.constructionYear,
    this.documentType,
    this.roomsCount,
    this.mastersCount,
    //
    this.city,
    this.district,
    this.quarter,
    this.alley,
    this.location,
    this.price,
  });

  factory Villa.fromJson(Map<String, dynamic> json) => _$VillaFromJson(json);
  Map<String, dynamic> toJson() => _$VillaToJson(this);
}
