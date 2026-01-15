class Buildings {
  final int id_building;
  final String name;
  final String location;
  final int construction_year;
  final String description;
  final int surface_area;
  final int id_typology;
  final int id_protection;
  final String coordinates;
  final bool validate;
  final List<String>? images;

  Buildings({
    required this.id_building,
    required this.name,
    required this.location,
    required this.construction_year,
    required this.description,
    required this.surface_area,
    required this.id_typology,
    required this.id_protection,
    required this.coordinates,
    required this.validate,
    this.images,
  });

  // Fábrica para crear un Edificio desde los datos de Supabase (Map)
  factory Buildings.fromMap(Map<String, dynamic> map) {
    // 1. Logica para sacar las imagenes de la lista de objetos
    List<String> extractedImages = [];
    if (map['building_images'] != null) {
      // Recorremos la lista de objetos y sacamos solo el 'image_url'
      extractedImages = (map['building_images'] as List)
          .map((item) => item['image_url'] as String)
          .toList();
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
      coordinates: map['coordinates'] ?? '',
      validate: map['validated'] ?? false,
      images: extractedImages,
    );
  }

  // Para enviar datos a Supabase
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'ubicacion': location,
      'construction_year': construction_year,
      'descripction': description,
      'surface_area': surface_area,
      'id_typology': id_typology,
      'id_protection': id_protection,
      'coordinates': coordinates,
      'validate': validate,
    };
  }
}
