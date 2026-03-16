import 'package:freezed_annotation/freezed_annotation.dart';

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
    var rawThemes = map['themes'];
    String finalThemes = '';
    if (rawThemes == null) {
      finalThemes = '';
    } else if (rawThemes is String) {
      finalThemes = rawThemes;
    } else if (rawThemes is List) {
      finalThemes = rawThemes.join(', ');
    } else {
      finalThemes = rawThemes.toString();
    }

    return PublicationDto(
      idPublication: map['id_publication'] is int
          ? map['id_publication']
          : int.tryParse(map['id_publication'].toString()) ?? 0,
      title: map['title'] ?? 'Sin título',
      description: map['description'] ?? '',
      themes: finalThemes,
      publicationEdition: map['publication_edition'] ?? '',
    );
  }
}