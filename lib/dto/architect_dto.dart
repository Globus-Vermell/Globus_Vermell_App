import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/json_helper.dart';

part 'architect_dto.freezed.dart';

@freezed
class ArchitectDto with _$ArchitectDto {
  const factory ArchitectDto({
    required int idArchitect,
    required String name,
    String? description,
    String? descriptionEs, 
    String? descriptionEn,
    String? descriptionFr,
    String? descriptionAr,
    int? birthYear,
    int? deathYear,
    String? nationality,
    String? nationalityEs, 
    String? nationalityEn,
    String? nationalityFr,
    String? nationalityAr,
  }) = _ArchitectDto;

  factory ArchitectDto.fromMap(Map<String, dynamic> map) {
    return ArchitectDto(
      idArchitect: JsonHelper.parseInt(map['id_architect']),
      name: map['name'].toString(),
      description: map['description']?.toString(),
      descriptionEs: map['description_es']?.toString(),
      descriptionEn: map['description_en']?.toString(),
      descriptionFr: map['description_fr']?.toString(),
      descriptionAr: map['description_ar']?.toString(),
      birthYear: map['birth_year'] != null ? JsonHelper.parseInt(map['birth_year']) : null,
      deathYear: map['death_year'] != null ? JsonHelper.parseInt(map['death_year']) : null,
      nationality: map['nationality']?.toString(),
      nationalityEs: map['nationality_es']?.toString(),
      nationalityEn: map['nationality_en']?.toString(),
      nationalityFr: map['nationality_fr']?.toString(),
      nationalityAr: map['nationality_ar']?.toString(),
    );
  }
}