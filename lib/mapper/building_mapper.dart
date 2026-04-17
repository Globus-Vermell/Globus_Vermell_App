import '../dto/building_dto.dart';
import '../entity/building_entity.dart';
import '../utils/app_constants.dart';

extension BuildingMapper on BuildingDto {
  Building toEntity() {
    final List<String> formattedImages = images.map((path) {
      if (path.startsWith('http')) return path;
      return '${AppConstants.baseUrl}$path';
    }).toList();

    return Building(
      idBuilding: idBuilding,
      name: name,
      location: location,
      constructionYear: constructionYear,

      description: description,
      descriptionEs: descriptionEs,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      descriptionFr: descriptionFr,

      surfaceArea: surfaceArea,
      idTypology: idTypology,
      idProtection: idProtection,
      validate: validate,
      images: formattedImages,
      typologyName: typologyName,
      protectionName: protectionName,
      latitude: latitude,
      longitude: longitude,
      architects: architects,
      reforms: reforms,
      prizes: prizes,

      publications: publications,
      publicationsEs: publicationsEs,
      publicationsEn: publicationsEn,
      publicationsAr: publicationsAr,
      publicationsFr: publicationsFr,

      uses: uses,
      usesEs: usesEs,
      usesEn: usesEn,
      usesAr: usesAr,
      usesFr: usesFr,
    );
  }
}
