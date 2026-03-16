class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No hay conexión a internet.']);
}

class ServerException implements Exception {
  final int statusCode;
  final String message;
  ServerException(this.statusCode, [this.message = 'Error en el servidor.']);
}