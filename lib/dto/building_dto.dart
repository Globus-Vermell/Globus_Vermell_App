import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/json_helper.dart';

part 'building_dto.freezed.dart';

@freezed
class BuildingDto with _$BuildingDto {
  const factory BuildingDto({
    required int idBuilding,
    required String name,
    required String location,
    required int constructionYear,
    required String description,
    required int surfaceArea,
    required int idTypology,
    required int idProtection,
    required bool validate,
    @Default([]) List<String> images,
    @Default('') String typologyName,
    @Default('') String protectionName,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default([]) List<String> architects,
    @Default([]) List<String> reforms,
    @Default([]) List<String> prizes,
    @Default([]) List<String> publications,
    @Default([]) List<String> uses,
  }) = _BuildingDto;

  factory BuildingDto.fromMap(Map<String, dynamic> map) {
    return BuildingDto(
      idBuilding: JsonHelper.parseInt(map['id_building']),
      name: map['name'].toString(),
      location: map['location'].toString(),
      constructionYear: JsonHelper.parseInt(map['construction_year']),
      description: map['description'].toString(),
      surfaceArea: JsonHelper.parseInt(map['surface_area']),
      idTypology: JsonHelper.parseInt(map['id_typology']),
      idProtection: JsonHelper.parseInt(map['id_protection']),
      validate: map['validated'],
      images: JsonHelper.extractImages(map['building_images']),
      typologyName:
          map['typologies']?['name']?.toString() ??
          map['typologyName']?.toString() ??
          '',
      protectionName:
          map['protections']?['level']?.toString() ??
          map['protectionName']?.toString() ??
          '',

      latitude: JsonHelper.parseDouble(map['latitude']),
      longitude: JsonHelper.parseDouble(map['longitude']),

      architects: JsonHelper.parseList(map['architects']),
      reforms: JsonHelper.parseList(map['reforms']),
      prizes: JsonHelper.parseList(map['prizes']),
      publications: JsonHelper.parseList(map['publications']),
      uses: JsonHelper.parseList(map['usos']),
    );
  }
}
