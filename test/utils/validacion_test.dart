import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/utils/validacion.dart';

void main() {
  test('acepta títulos válidos después de quitar espacios externos', () {
    expect(validarTitulo('  Revisar tareas  '), isNull);
    expect(validarTitulo('x' * 200), isNull);
  });

  test('rechaza títulos vacíos o compuestos solo por espacios', () {
    expect(validarTitulo(''), 'Escribe un título para la tarea.');
    expect(validarTitulo(' \t\n '), 'Escribe un título para la tarea.');
  });

  test('rechaza títulos mayores a 200 caracteres', () {
    expect(
      validarTitulo('x' * 201),
      'El título no puede superar los 200 caracteres.',
    );
  });
}
