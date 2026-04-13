import 'package:isar/isar.dart';

part 'building_entity.g.dart';

@collection
class Building {
  Id idBuilding;

  final String name;
  final String location;
  final int constructionYear;
  
  final String description;
  final String? descriptionEs;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? descriptionFr;

  final int surfaceArea;
  final int idTypology;
  final int idProtection;
  final bool validate;
  final List<String> images;
  final String typologyName;
  final String protectionName;
  final double latitude;
  final double longitude;
  final List<String> architects;
  final List<String> reforms;
  final List<String> prizes;
  
  final List<String> publications;
  final List<String>? publicationsEs;
  final List<String>? publicationsEn;
  final List<String>? publicationsAr;
  final List<String>? publicationsFr;

  final List<String> uses;
  final List<String>? usesEs;
  final List<String>? usesEn;
  final List<String>? usesAr;
  final List<String>? usesFr;

  Building({
    required this.idBuilding,
    required this.name,
    required this.location,
    required this.constructionYear,
    required this.description,
    this.descriptionEs,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionFr,
    required this.surfaceArea,
    required this.idTypology,
    required this.idProtection,
    required this.validate,
    required this.images,
    required this.typologyName,
    required this.protectionName,
    required this.latitude,
    required this.longitude,
    required this.architects,
    required this.reforms,
    required this.prizes,
    required this.publications,
    this.publicationsEs,
    this.publicationsEn,
    this.publicationsAr,
    this.publicationsFr,
    required this.uses,
    this.usesEs,
    this.usesEn,
    this.usesAr,
    this.usesFr,
  });

  int get id => idBuilding;

  // ✨ Robotitos Traductores de Edificios UwU ✨
  String getLocalizedDescription(String langCode) {
    if (langCode == 'es' && descriptionEs?.isNotEmpty == true) return descriptionEs!;
    if (langCode == 'en' && descriptionEn?.isNotEmpty == true) return descriptionEn!;
    if (langCode == 'fr' && descriptionFr?.isNotEmpty == true) return descriptionFr!;
    if (langCode == 'ar' && descriptionAr?.isNotEmpty == true) return descriptionAr!;
    return description;
  }

  List<String> getLocalizedUses(String langCode) {
    if (langCode == 'es' && usesEs?.isNotEmpty == true) return usesEs!;
    if (langCode == 'en' && usesEn?.isNotEmpty == true) return usesEn!;
    if (langCode == 'fr' && usesFr?.isNotEmpty == true) return usesFr!;
    if (langCode == 'ar' && usesAr?.isNotEmpty == true) return usesAr!;
    return uses;
  }

  List<String> getLocalizedPublications(String langCode) {
    if (langCode == 'es' && publicationsEs?.isNotEmpty == true) return publicationsEs!;
    if (langCode == 'en' && publicationsEn?.isNotEmpty == true) return publicationsEn!;
    if (langCode == 'fr' && publicationsFr?.isNotEmpty == true) return publicationsFr!;
    if (langCode == 'ar' && publicationsAr?.isNotEmpty == true) return publicationsAr!;
    return publications;
  }
}