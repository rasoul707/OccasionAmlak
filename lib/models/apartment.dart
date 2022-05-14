import 'package:json_annotation/json_annotation.dart';

part 'apartment.g.dart';

@JsonSerializable()
class Apartment {
  String? id;

  int? floorsCount;
  int? unitsCount;

  int? floor;

  double? area;

  int? roomsCount;
  int? mastersCount;

  String? documentType;

  List<String>? equipments;

  // ####

  String? city;
  String? district;

  String? quarter;
  String? alley;
  List<double>? location;
  int? price;

  // ####

  Apartment({
    this.id,
    this.floorsCount,
    this.unitsCount,
    this.floor,
    this.area,
    this.roomsCount,
    this.mastersCount,
    this.documentType,
    this.equipments,
    //
    this.city,
    this.district,
    this.quarter,
    this.alley,
    this.location,
    this.price,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) =>
      _$ApartmentFromJson(json);
  Map<String, dynamic> toJson() => _$ApartmentToJson(this);
}
