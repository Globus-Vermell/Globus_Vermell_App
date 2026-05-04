import '../dto/architect_dto.dart';
import '../entity/architect_entity.dart';

extension ArchitectMapper on ArchitectDto {
  Architect toEntity() {
    return Architect(
      idArchitect: idArchitect,
      name: name,
      description: description,
      birthYear: birthYear,
      deathYear: deathYear,
      nationality: nationality,
    );
  }
}