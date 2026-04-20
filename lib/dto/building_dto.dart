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
    String? descriptionEs,
    String? descriptionEn,
    String? descriptionAr,
    String? descriptionFr,

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
    List<String>? publicationsEs,
    List<String>? publicationsEn,
    List<String>? publicationsAr,
    List<String>? publicationsFr,

    @Default([]) List<String> uses,
    List<String>? usesEs,
    List<String>? usesEn,
    List<String>? usesAr,
    List<String>? usesFr,

    @Default([]) List<dynamic> extraDescriptions,
  }) = _BuildingDto;

  factory BuildingDto.fromMap(Map<String, dynamic> map) {
    return BuildingDto(
      idBuilding: JsonHelper.parseInt(map['id_building']),
      name: map['name'].toString(),
      location: map['location'].toString(),
      constructionYear: JsonHelper.parseInt(map['construction_year']),

      description: map['description'].toString(),
      descriptionEs: map['description_es']?.toString(),
      descriptionEn: map['description_en']?.toString(),
      descriptionAr: map['description_ar']?.toString(),
      descriptionFr: map['description_fr']?.toString(),

      surfaceArea: JsonHelper.parseInt(map['surface_area']),
      idTypology: JsonHelper.parseInt(map['id_typology']),
      idProtection: JsonHelper.parseInt(map['id_protection']),
      validate: map['validated'] ?? false,
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
      publicationsEs: JsonHelper.parseList(map['publications_es']),
      publicationsEn: JsonHelper.parseList(map['publications_en']),
      publicationsAr: JsonHelper.parseList(map['publications_ar']),
      publicationsFr: JsonHelper.parseList(map['publications_fr']),

      uses: JsonHelper.parseList(map['usos']),
      usesEs: JsonHelper.parseList(map['uses_es'] ?? map['usos_es']),
      usesEn: JsonHelper.parseList(map['uses_en'] ?? map['usos_en']),
      usesAr: JsonHelper.parseList(map['uses_ar'] ?? map['usos_ar']),
      usesFr: JsonHelper.parseList(map['uses_fr'] ?? map['usos_fr']),

      extraDescriptions: map['extra_descriptions'] as List<dynamic>? ?? [],
    );
  }
}
