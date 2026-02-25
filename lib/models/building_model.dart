class Buildings {
  final int idBuilding;
  final String name;
  final String location;
  final int constructionYear;
  final String description;
  final int surfaceArea;
  final int idTypology;
  final int idProtection;
  final bool validate;
  final List<String> images;
  final String? typologyName;
  final String? protectionName;

  final double latitude;
  final double longitude;

  final List<String> architects;
  final List<String> reforms;
  final List<String> prizes;
  final List<String> publications;

  final List<String> usos;

  Buildings({
    required this.idBuilding,
    required this.name,
    required this.location,
    required this.constructionYear,
    required this.description,
    required this.surfaceArea,
    required this.idTypology,
    required this.idProtection,
    required this.validate,
    this.images = const [],
    this.typologyName,
    this.protectionName,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.usos = const [],
    this.architects = const [],
    this.reforms = const [],
    this.prizes = const [],
    this.publications = const [],
  });

  factory Buildings.fromMap(Map<String, dynamic> map) {
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

    String? extractedTypology;
    if (map['typologies'] != null && map['typologies'] is Map) {
      extractedTypology = map['typologies']['name'];
    } else if (map['typologyName'] != null) {
      extractedTypology = map['typologyName'];
    }

    String? extractedProtection;
    if (map['protections'] != null && map['protections'] is Map) {
      extractedProtection = map['protections']['level'];
    } else if (map['protectionName'] != null) {
      extractedProtection = map['protectionName'];
    }

    return Buildings(
      idBuilding: map['id_building'] ?? 0,
      name: map['name'] ?? 'Sin nombre',
      location: map['location'] ?? 'Sin ubicación',
      constructionYear: map['construction_year'] ?? 0,
      description: map['description'] ?? 'Sin descripción',
      surfaceArea: map['surface_area'] ?? 0,
      idTypology: map['id_typology'] ?? 0,
      idProtection: map['id_protection'] ?? 0,
      validate: map['validated'] ?? false,
      images: extractedImages,
      typologyName: extractedTypology,
      usos: _parseList(map['usos']),
      protectionName: extractedProtection,

      latitude: (map['latitude'] != null)
          ? double.tryParse(map['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: (map['longitude'] != null)
          ? double.tryParse(map['longitude'].toString()) ?? 0.0
          : 0.0,

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
