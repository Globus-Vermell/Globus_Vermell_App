import 'package:isar/isar.dart';

part 'publication_entity.g.dart';

@collection
class Publication {
  Id idPublication;

  final String title;
  final String? titleEs;
  final String? titleEn;
  final String? titleFr;
  final String? titleAr;

  final String description;
  final String? descriptionEs;
  final String? descriptionEn;
  final String? descriptionFr;
  final String? descriptionAr;

  final String themes;
  final String publicationEdition;

  Publication({
    required this.idPublication,
    required this.title,
    this.titleEs,
    this.titleEn,
    this.titleFr,
    this.titleAr,
    required this.description,
    this.descriptionEs,
    this.descriptionEn,
    this.descriptionFr,
    this.descriptionAr,
    required this.themes,
    required this.publicationEdition,
  });

  // Traductores de Publicaciones
  String getLocalizedTitle(String langCode) {
    if (langCode == 'es' && titleEs?.isNotEmpty == true) return titleEs!;
    if (langCode == 'en' && titleEn?.isNotEmpty == true) return titleEn!;
    if (langCode == 'fr' && titleFr?.isNotEmpty == true) return titleFr!;
    if (langCode == 'ar' && titleAr?.isNotEmpty == true) return titleAr!;
    return title;
  }

  String getLocalizedDescription(String langCode) {
    if (langCode == 'es' && descriptionEs?.isNotEmpty == true) {
      return descriptionEs!;
    }
    if (langCode == 'en' && descriptionEn?.isNotEmpty == true) {
      return descriptionEn!;
    }
    if (langCode == 'fr' && descriptionFr?.isNotEmpty == true) {
      return descriptionFr!;
    }
    if (langCode == 'ar' && descriptionAr?.isNotEmpty == true) {
      return descriptionAr!;
    }
    return description;
  }
}
