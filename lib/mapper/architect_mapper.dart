import '../dto/architect_dto.dart';
import '../entity/architect_entity.dart';

extension ArchitectMapper on ArchitectDto {
  Architect toEntity() {
    return Architect(
      idArchitect: idArchitect,
      name: name,
      description: description,
      descriptionEs: descriptionEs,
      descriptionEn: descriptionEn,
      descriptionFr: descriptionFr,
      descriptionAr: descriptionAr,
      birthYear: birthYear,
      deathYear: deathYear,
      nationality: nationality,
      nationalityEs: nationalityEs,
      nationalityEn: nationalityEn,
      nationalityFr: nationalityFr,
      nationalityAr: nationalityAr,
    );
  }
}