import 'package:json_annotation/json_annotation.dart';
import '../models/apartment.dart';
import '../models/commercial.dart';
import '../models/hectare.dart';
import '../models/land.dart';
import '../models/villa.dart';

part 'casefile.g.dart';

@JsonSerializable()
class CaseFile {
  String? id;
  String? type;

  String? city;
  String? district;
  String? quarter;
  String? alley;
  List<double>? location;
  int? price;

  List<int>? pictures;
  int? thumb;

  Villa? villa;
  Apartment? apartment;
  Commercial? commercial;
  Hectare? hectare;
  Land? land;

  CaseFile({
    this.id,
    this.type,
    this.city,
    this.district,
    this.quarter,
    this.alley,
    this.location,
    this.price,
    this.pictures,
    this.thumb,
    this.villa,
    this.apartment,
    this.commercial,
    this.hectare,
    this.land,
  });

  factory CaseFile.fromJson(Map<String, dynamic> json) =>
      _$CaseFileFromJson(json);
  Map<String, dynamic> toJson() => _$CaseFileToJson(this);
}


/*
NOTE:
in gpart file you should change by hand after build

'villa': instance.villa == null ? null : instance.villa!.toJson(),
'apartment': instance.apartment == null ? null : instance.apartment!.toJson(),
'commercial': instance.commercial == null ? null : instance.commercial!.toJson(),
'hectare': instance.hectare == null ? null : instance.hectare!.toJson(),
'land': instance.land == null ? null : instance.land!.toJson(),


 */
