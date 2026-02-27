import 'package:flutter_test/flutter_test.dart';
import 'package:globus_vermell_app/services/publications_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Creamos un servidor falso para poder simular las llamadas a la API.
class MockHttpClient extends Mock implements http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {
  late PublicationService service;
  late MockHttpClient mockHttpClient;
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    service = PublicationService();
    //Le introducimos el cliente falso que hemos creado en el test para confirmar que el error funciona.
    service.client = mockHttpClient;
  });

  group('PublicationService Tests -', () {

    test('Debe lanzar NetworkError cuando la API devuelve un Error 500', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response('Internal Server Error', 500),
      );
      expect(
            () async => await service.getPublications(),
        throwsA(isA<Exception>()),
      );
    });
    //Test de su correcto funcionamiento del servidor.

  });
}