import '../dto/publication_dto.dart';
import '../entity/publication_entity.dart';

extension PublicationMapper on PublicationDto {
  Publication toEntity() {
    return Publication(
      idPublication: idPublication,
      title: title,
      titleEs: titleEs,
      titleEn: titleEn,
      titleFr: titleFr,
      titleAr: titleAr,

      description: description,
      descriptionEs: descriptionEs,
      descriptionEn: descriptionEn,
      descriptionFr: descriptionFr,
      descriptionAr: descriptionAr,

      themes: themes,
      publicationEdition: publicationEdition,
    );
  }
}