import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/json_helper.dart';

part 'publication_dto.freezed.dart';

@freezed
class PublicationDto with _$PublicationDto {
  const factory PublicationDto({
    required int idPublication,
    required String title,
    String? titleEs,
    String? titleEn,
    String? titleFr,
    String? titleAr,
    required String description,
    String? descriptionEs,
    String? descriptionEn,
    String? descriptionFr,
    String? descriptionAr,
    required String themes,
    required String publicationEdition,
  }) = _PublicationDto;

  factory PublicationDto.fromMap(Map<String, dynamic> map) {
    return PublicationDto(
      idPublication: JsonHelper.parseInt(map['id_publication']),
      title: map['title']?.toString() ?? 'Sin título',
      titleEs: map['title_es']?.toString(),
      titleEn: map['title_en']?.toString(),
      titleFr: map['title_fr']?.toString(),
      titleAr: map['title_ar']?.toString(),

      description: map['description']?.toString() ?? '',
      descriptionEs: map['description_es']?.toString(),
      descriptionEn: map['description_en']?.toString(),
      descriptionFr: map['description_fr']?.toString(),
      descriptionAr: map['description_ar']?.toString(),

      themes: JsonHelper.parseStringOrList(map['themes']),
      publicationEdition: map['publication_edition']?.toString() ?? '',
    );
  }
}
