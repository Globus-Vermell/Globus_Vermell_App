import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:globus_vermell_app/models/building_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globus_vermell_app/services/building_service.dart';

//Creamos un servidor falso para poder simular las llamadas a la API.
class MockHttpClient extends Mock implements http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {
  late BuildingService service;
  late MockHttpClient mockHttpClient;
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    service = BuildingService();
    //Le introducimos el cliente falso que hemos creado en el test para confirmar que el error funciona.
    service.client = mockHttpClient;
    service.firstPageLoading = false;
  });

  group('BuildingService Tests -', () {

    test('Debe lanzar NetworkError cuando la API devuelve un Error 500', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response('Internal Server Error', 500),
      );
      expect(
            () async => await service.getBuildings(page: 1),
        throwsA(isA<Exception>()),
      );
    });

    test('Debe retornar una lista de Buildings cuando la API devuelve un Response 200', () async {
      final mockResponse = {
        'buildings': [
          {
            'id_building': 1,
            'name': 'Edificio de Prueba',
            'location': 'Barcelona',
            'construction_year': 2023,
            'description': 'Una descripción',
            'surface_area': 100,
            'id_typology': 1,
            'id_protection': 1,
            'validated': true,
          },
          {
            'id_building': 2,
            'name': 'Edificio de Prueba 2',
            'location': 'Barcelona',
            'construction_year': 2023,
            'description': 'Una descripción',
            'surface_area': 100,
            'id_typology': 1,
            'id_protection': 1,
            'validated': true,
          }
        ]
      };

      when(() => mockHttpClient.get(any())).thenAnswer(
            (_) async => http.Response(jsonEncode(mockResponse), 200),
      );
      final result = await service.getBuildings(page: 1);

      expect(result, isA<List<Building>>());
      expect(result.length, 2, reason: 'Debe haber dos edificios');
      expect(result.first.name,
          'Edificio de Prueba',
          reason: 'El primer edificio debe llamarse Edificio de Prueba');
      expect(result.last.idBuilding, 2,
          reason: 'El último edificio debe tener el ID 2');
    });
  });
}