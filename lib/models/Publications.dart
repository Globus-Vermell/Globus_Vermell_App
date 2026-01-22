class Publication {
  final int idPublication;
  final String title;
  final String description;
  final String themes;
  final String publicationEdition;

  Publication({
    required this.idPublication,
    required this.title,
    required this.description,
    required this.themes,
    required this.publicationEdition,
  });

  factory Publication.fromMap(Map<String, dynamic> map) {
    return Publication(
      idPublication: map['id_publication'] ?? 0,
      title: map['title'] ?? 'Sin título',
      description: map['description'] ?? '',
      themes: map['themes'] ?? '',
      publicationEdition: map['publication_edition'] ?? '',
    );
  }
}
