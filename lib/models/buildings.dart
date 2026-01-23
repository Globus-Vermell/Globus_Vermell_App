class Buildings {
  final int id_building;
  final String name;
  final String location;
  final int construction_year;
  final String description;
  final int surface_area;
  final int id_typology;
  final int id_protection;
  final bool validate;
  final List<String>? images;
  final String? typologyName;
  final String? protectionName;

  // Listas de datos extra
  final List<String> architects;
  final List<String> reforms;
  final List<String> prizes;
  final List<String> publications;

  Buildings({
    required this.id_building,
    required this.name,
    required this.location,
    required this.construction_year,
    required this.description,
    required this.surface_area,
    required this.id_typology,
    required this.id_protection,
    required this.validate,
    this.images,
    this.typologyName,
    this.protectionName,
    this.architects = const [],
    this.reforms = const [],
    this.prizes = const [],
    this.publications = const [],
  });

  factory Buildings.fromMap(Map<String, dynamic> map) {
    // Mapeo de IMÁGENES
    List<String> extractedImages = [];
    if (map['building_images'] != null) {
      if (map['building_images'] is List) {
        extractedImages = (map['building_images'] as List)
            .map((item) {
              if (item is Map) return item['image_url'] as String? ?? '';
              if (item is String) return item;
              return '';
            })
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    if (map['publications'] != null || map['building_publications'] != null) {
      print(" DEBUG EDIFICIO: ${map['name']}");
      print(" publications (raw): ${map['publications']}");
      print(" building_publications (raw): ${map['building_publications']}");
    }

    // Mapeo de TIPOLOGÍA (Objeto -> String)
    String? extractedTypology;
    if (map['typologies'] != null && map['typologies'] is Map) {
      extractedTypology = map['typologies']['name'];
    } else if (map['typologyName'] != null) {
      extractedTypology = map['typologyName'];
    }

    // Mapeo de PROTECCIÓN (Objeto -> String)
    String? extractedProtection;
    if (map['protections'] != null && map['protections'] is Map) {
      extractedProtection = map['protections']['level'];
    } else if (map['protectionName'] != null) {
      extractedProtection = map['protectionName'];
    }

    return Buildings(
      id_building: map['id_building'] ?? 0,
      name: map['name'] ?? 'Sin nombre',
      location: map['location'] ?? 'Sin ubicación',
      construction_year: map['construction_year'] ?? 0,
      description: map['description'] ?? 'Sin descripción',
      surface_area: map['surface_area'] ?? 0,
      id_typology: map['id_typology'] ?? 0,
      id_protection: map['id_protection'] ?? 0,
      validate: map['validated'] ?? false,
      images: extractedImages,
      typologyName: extractedTypology,
      protectionName: extractedProtection,

      architects: _parseList(map['architects']),
      reforms: _parseList(map['reforms']),
      prizes: _parseList(map['prizes']),
      publications: _parseList(map['publications']),
    );
  }

  static List<String> _parseList(dynamic input) {
    if (input == null) return [];
    if (input is! List) return [];

    return input
        .map((item) {
          if (item is String) return item;

          if (item is Map) {
            if (item.containsKey('name')) return item['name'].toString();
            if (item.containsKey('title')) return item['title'].toString();
            return '';
          }
          return '';
        })
        .where((item) => item.isNotEmpty)
        .toList()
        .cast<String>();
  }
}
