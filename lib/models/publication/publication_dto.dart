import 'package:freezed_annotation/freezed_annotation.dart';
import '../../utils/json_helper.dart';

part 'publication_dto.freezed.dart';

@freezed
class PublicationDto with _$PublicationDto {
  const factory PublicationDto({
    required int idPublication,
    required String title,
    required String description,
    required String themes,
    required String publicationEdition,
  }) = _PublicationDto;

  factory PublicationDto.fromMap(Map<String, dynamic> map) {
    return PublicationDto(
      idPublication: JsonHelper.parseInt(map['id_publication']),
      title: map['title']?.toString() ?? 'Sin título',
      description: map['description']?.toString() ?? '',
      themes: JsonHelper.parseStringOrList(map['themes']),
      publicationEdition: map['publication_edition']?.toString() ?? '',
    );
  }
}