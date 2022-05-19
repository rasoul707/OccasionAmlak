import 'package:json_annotation/json_annotation.dart';

part 'apartment.g.dart';

@JsonSerializable()
class Apartment {
  int? floorsCount;
  int? unitsCount;
  int? floor;
  double? area;
  int? roomsCount;
  int? mastersCount;
  String? documentType;
  List<String>? equipments;

  Apartment({
    this.floorsCount,
    this.unitsCount,
    this.floor,
    this.area,
    this.roomsCount,
    this.mastersCount,
    this.documentType,
    this.equipments,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) =>
      _$ApartmentFromJson(json);
  Map<String, dynamic> toJson() => _$ApartmentToJson(this);
}
