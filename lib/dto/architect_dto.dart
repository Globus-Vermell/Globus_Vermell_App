import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/json_helper.dart';

part 'architect_dto.freezed.dart';

@freezed
class ArchitectDto with _$ArchitectDto {
  const factory ArchitectDto({
    required int idArchitect,
    required String name,
    String? description,
    int? birthYear,
    int? deathYear,
    String? nationality,
  }) = _ArchitectDto;

  factory ArchitectDto.fromMap(Map<String, dynamic> map) {
    return ArchitectDto(
      idArchitect: JsonHelper.parseInt(map['id_architect']),
      name: map['name'].toString(),
      description: map['description']?.toString(),
      birthYear: map['birth_year'] != null ? JsonHelper.parseInt(map['birth_year']) : null,
      deathYear: map['death_year'] != null ? JsonHelper.parseInt(map['death_year']) : null,
      nationality: map['nationality']?.toString(),
    );
  }
}