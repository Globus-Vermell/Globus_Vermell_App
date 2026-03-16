import 'package:freezed_annotation/freezed_annotation.dart';

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
    List<String> extractedImages = [];
    if (map['building_images'] != null && map['building_images'] is List) {
      extractedImages = (map['building_images'] as List)
          .map((item) {
        if (item is Map) return item['image_url'] as String? ?? '';
        if (item is String) return item;
        return '';
      })
          .where((s) => s.isNotEmpty)
          .toList();
    }

    String extractedTypology = '';
    if (map['typologies'] != null && map['typologies'] is Map) {
      extractedTypology = map['typologies']['name'];
    } else if (map['typologyName'] != null) {
      extractedTypology = map['typologyName'];
    }

    String extractedProtection = '';
    if (map['protections'] != null && map['protections'] is Map) {
      extractedProtection = map['protections']['level'];
    } else if (map['protectionName'] != null) {
      extractedProtection = map['protectionName'];
    }

    return BuildingDto(
      idBuilding: map['id_building'] ?? 0,
      name: map['name'] ?? 'Sin nombre',
      location: map['location'] ?? 'Sin ubicación',
      constructionYear: map['construction_year'] ?? 0,
      description: map['description'] ?? 'Sin descripción',
      surfaceArea: map['surface_area'] ?? 0,
      idTypology: map['id_typology'] ?? 0,
      idProtection: map['id_protection'] ?? 0,
      validate: map['validated'] ?? false,
      images: extractedImages,
      typologyName: extractedTypology,
      uses: parseList(map['usos']),
      protectionName: extractedProtection,
      latitude: (map['latitude'] != null)
          ? double.tryParse(map['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: (map['longitude'] != null)
          ? double.tryParse(map['longitude'].toString()) ?? 0.0
          : 0.0,
      architects: parseList(map['architects']),
      reforms: parseList(map['reforms']),
      prizes: parseList(map['prizes']),
      publications: parseList(map['publications']),
    );
  }
}

List<String> parseList(Object? input) {
  if (input == null || input is! List) return [];
  return input
      .map((item) {
    if (item is String) return item;
    if (item is Map) {
      if (item.containsKey('name')) return item['name'].toString();
      if (item.containsKey('title')) return item['title'].toString();
    }
    return '';
  })
      .where((item) => item.isNotEmpty)
      .toList();
}