class Buildings {
  final int id_building;
  final String name;
  final String location;
  final int construction_year;
  final String descripction;
  final int surface_area;
  final int id_typology;
  final int id_protection;
  final String coordinates;
  final bool validate;

  Buildings({
    required this.id_building,
    required this.name,
    required this.location,
    required this.construction_year,
    required this.descripction,
    required this.surface_area,
    required this.id_typology,
    required this.id_protection,
    required this.coordinates,
    required this.validate,
  });

  // Fábrica para crear un Edificio desde los datos de Supabase (Map)
  factory Buildings.fromMap(Map<String, dynamic> map) {
    return Buildings(
      id_building: map['id_building'] ?? 0,
      name: map['name'] ?? 'Sin nombre',
      location: map['location'] ?? 'Sin ubicación',
      construction_year: map['construction_year'] ?? 0,
      descripction: map['descripction'] ?? 'Sin descripción',
      surface_area: map['surface_area'] ?? 0,
      id_typology: map['id_typology'] ?? 0,
      id_protection: map['id_protection'] ?? 0,
      coordinates: map['coordinates'] ?? '',
      validate: map['validate'] ?? false,
    );
  }

  // Para enviar datos a Supabase
  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'ubicacion': location,
      'construction_year': construction_year,
      'descripction': descripction,
      'surface_area': surface_area,
      'id_typology': id_typology,
      'id_protection': id_protection,
      'coordinates': coordinates,
      'validate': validate,
    };
  }
}
