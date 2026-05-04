import 'package:isar/isar.dart';

part 'architect_entity.g.dart';

@collection
class Architect {
  Id idArchitect;
  
  final String name;
  final String? description;
  final String? descriptionEs;
  final String? descriptionEn;
  final String? descriptionFr;
  final String? descriptionAr;
  final int? birthYear;
  final int? deathYear;
  final String? nationality;
  final String? nationalityEs;
  final String? nationalityEn;
  final String? nationalityFr;
  final String? nationalityAr;

  Architect({
    required this.idArchitect,
    required this.name,
    this.description,
    this.descriptionEs,
    this.descriptionEn,
    this.descriptionFr,
    this.descriptionAr,
    this.birthYear,
    this.deathYear,
    this.nationality,
    this.nationalityEs,
    this.nationalityEn,
    this.nationalityFr,
    this.nationalityAr,
  });
  
  int get id => idArchitect;

  String getLocalizedDescription(String langCode) {
    switch (langCode) {
      case 'es': return descriptionEs ?? description ?? '';
      case 'en': return descriptionEn ?? description ?? '';
      case 'fr': return descriptionFr ?? description ?? '';
      case 'ar': return descriptionAr ?? description ?? '';
      default: return description ?? ''; // Catalán por defecto
    }
  }

  String getLocalizedNationality(String langCode) {
    switch (langCode) {
      case 'es': return nationalityEs ?? nationality ?? '';
      case 'en': return nationalityEn ?? nationality ?? '';
      case 'fr': return nationalityFr ?? nationality ?? '';
      case 'ar': return nationalityAr ?? nationality ?? '';
      default: return nationality ?? ''; // Catalán por defecto
    }
  }
}