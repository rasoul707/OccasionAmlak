import 'package:json_annotation/json_annotation.dart';

part 'villa.g.dart';

@JsonSerializable()
class Villa {
  String? type;
  double? landArea;
  double? buildingArea;
  int? constructionYear;
  String? documentType;
  int? roomsCount;
  int? mastersCount;

  Villa({
    this.type,
    this.landArea,
    this.buildingArea,
    this.constructionYear,
    this.documentType,
    this.roomsCount,
    this.mastersCount,
  });

  factory Villa.fromJson(Map<String, dynamic> json) => _$VillaFromJson(json);
  Map<String, dynamic> toJson() => _$VillaToJson(this);
}
