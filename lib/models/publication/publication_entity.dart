import 'package:isar/isar.dart';

part 'publication_entity.g.dart';

@collection
class Publication {
  Id idPublication;

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
}
