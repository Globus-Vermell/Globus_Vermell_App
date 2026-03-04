import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:globus_vermell_app/models/publication_model.dart';
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
    test(
      'Debe lanzar NetworkError cuando la API devuelve un Error 500',
      () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response('Internal Server Error', 500));
        expect(
          () async => await service.getPublications(),
          throwsA(isA<Exception>()),
        );
      },
    );
    test(
      'Debe retornar una lista de Publications cuando la API devuelve un Response 200',
      () async {
        final mockResponse = {
          'publications': [
            {
              'id_publication': 1,
              'title': 'Publicació de Prueba',
              'description': 'Una descripción',
              'themes': ['Tema 1', 'Tema 2'],
              'publication_edition': '2023',
            },
            {
              'id_publication': 2,
              'title': 'Publicació de Prueba 2',
              'description': 'Una descripción',
              'themes': ['Tema 1', 'Tema 2'],
              'publication_edition': '2025',
            },
          ],
        };

        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));
        final result = await service.getPublications();

        expect(result, isA<List<Publication>>());
        expect(result.length, 2, reason: 'Debe haber dos edificios');
        expect(
          result.first.title,
          'Publicació de Prueba',
          reason: 'La primera publicació debe llamarse Publicació de Prueba',
        );
        expect(
          result.last.idPublication,
          2,
          reason: 'El último edificio debe tener el ID 2',
        );
      },
    );
  });
}
