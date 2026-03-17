import 'package:flutter_test/flutter_test.dart';
import 'package:globus_vermell_app/utils/json_helper.dart';

void main() {
  group('JsonHelper Tests -', () {
    test(
      'parseInt debería devolver un entero válido ante cualquier entrada',
      () {
        expect(JsonHelper.parseInt(5), 5);
        expect(JsonHelper.parseInt('42'), 42);
        expect(JsonHelper.parseInt(null), 0);
        expect(JsonHelper.parseInt('texto_basura'), 0);
      },
    );

    test('parseDouble debería devolver un decimal válido', () {
      expect(JsonHelper.parseDouble(3.14), 3.14);
      expect(JsonHelper.parseDouble('2.5'), 2.5);
      expect(JsonHelper.parseDouble(null), 0.0);
      expect(JsonHelper.parseDouble('error'), 0.0);
    });

    test('parseList debería limpiar listas mixtas o nulas', () {
      final listaSucia = [
        'Arquitecto 1',
        null,
        {'name': 'Arquitecto 2'},
        42,
      ];
      final resultado = JsonHelper.parseList(listaSucia);

      expect(resultado.length, 2);
      expect(resultado.contains('Arquitecto 1'), true);
      expect(resultado.contains('Arquitecto 2'), true);
      expect(JsonHelper.parseList(null), []);
    });
  });
}
