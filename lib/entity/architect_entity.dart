import 'package:isar/isar.dart';

part 'architect_entity.g.dart';

@collection
class Architect {
  Id idArchitect;
  
  final String name;
  final String? description;
  final int? birthYear;
  final int? deathYear;
  final String? nationality;

  Architect({
    required this.idArchitect,
    required this.name,
    this.description,
    this.birthYear,
    this.deathYear,
    this.nationality,
  });
  
  int get id => idArchitect;
}