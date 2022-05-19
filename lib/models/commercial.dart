import 'package:json_annotation/json_annotation.dart';

part 'commercial.g.dart';

@JsonSerializable()
class Commercial {
  String? type;
  double? area;
  String? documentType;
  int? floor;
  double? commercialArea;

  Commercial({
    this.type,
    this.area,
    this.documentType,
    this.floor,
    this.commercialArea,
  });

  factory Commercial.fromJson(Map<String, dynamic> json) =>
      _$CommercialFromJson(json);
  Map<String, dynamic> toJson() => _$CommercialToJson(this);
}
