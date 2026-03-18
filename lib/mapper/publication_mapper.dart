import '../dto/publication_dto.dart';
import '../entity/publication_entity.dart';

extension PublicationMapper on PublicationDto {
  Publication toEntity() {
    return Publication(
      idPublication: idPublication,
      title: title,
      description: description,
      themes: themes,
      publicationEdition: publicationEdition,
    );
  }
}
