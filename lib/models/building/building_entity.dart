import 'package:isar/isar.dart';

part 'building_entity.g.dart';

@collection
class Building {
  Id idBuilding;

  final String name;
  final String location;
  final int constructionYear;
  final String description;
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
  final List<String> uses;

  Building({
    required this.idBuilding,
    required this.name,
    required this.location,
    required this.constructionYear,
    required this.description,
    required this.surfaceArea,
    required this.idTypology,
    required this.idProtection,
    required this.validate,
    required this.images,
    required this.typologyName,
    required this.protectionName,
    required this.latitude,
    required this.longitude,
    required this.uses,
    required this.architects,
    required this.reforms,
    required this.prizes,
    required this.publications,
  });
}
