import '../dto/building_dto.dart';
import '../entity/building_entity.dart';

extension BuildingMapper on BuildingDto {
  Building toEntity() {
    return Building(
      idBuilding: idBuilding,
      name: name,
      location: location,
      constructionYear: constructionYear,
      description: description,
      surfaceArea: surfaceArea,
      idTypology: idTypology,
      idProtection: idProtection,
      validate: validate,
      images: images,
      typologyName: typologyName,
      protectionName: protectionName,
      latitude: latitude,
      longitude: longitude,
      architects: architects,
      reforms: reforms,
      prizes: prizes,
      publications: publications,
      uses: uses,
    );
  }
}
