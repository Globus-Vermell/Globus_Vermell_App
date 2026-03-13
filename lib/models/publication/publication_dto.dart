class PublicationDto {
  final int idPublication;
  final String title;
  final String description;
  final String themes;
  final String publicationEdition;

  PublicationDto({
    required this.idPublication,
    required this.title,
    required this.description,
    required this.themes,
    required this.publicationEdition,
  });

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
