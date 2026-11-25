import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('inserta y consulta una tarea', () async {
    final id = await database.insertarTarea('Preparar prueba');

    final tareas = await database.observarTareas().first;

    expect(tareas, hasLength(1));
    expect(tareas.single.id, id);
    expect(tareas.single.titulo, 'Preparar prueba');
    expect(tareas.single.completada, isFalse);
  });

  test('edita, cambia el estado y elimina una tarea por id', () async {
    final id = await database.insertarTarea('Título original');

    expect(await database.actualizarTitulo(id, 'Título actualizado'), 1);
    expect(await database.cambiarEstado(id, true), 1);

    final tarea = (await database.observarTareas().first).single;
    expect(tarea.titulo, 'Título actualizado');
    expect(tarea.completada, isTrue);

    expect(await database.eliminarTarea(id), 1);
    expect(await database.observarTareas().first, isEmpty);
  });
}
