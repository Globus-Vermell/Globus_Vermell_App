class JsonHelper {
  static List<String> extractImages(dynamic data) {
    if (data == null || data is! List) return [];
    return data.map((item) {
      if (item is Map) return item['image_url']?.toString() ?? '';
      if (item is String) return item;
      return '';
    }).where((s) => s.isNotEmpty).toList();
  }

  static List<String> parseList(dynamic input) {
    if (input == null || input is! List) return [];
    return input.map((item) {
      if (item is String) return item;
      if (item is Map) {
        if (item.containsKey('name')) return item['name'].toString();
        if (item.containsKey('title')) return item['title'].toString();
      }
      return '';
    }).where((item) => item.isNotEmpty).toList();
  }

  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static String parseStringOrList(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }
}