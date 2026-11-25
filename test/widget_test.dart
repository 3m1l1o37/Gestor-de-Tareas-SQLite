import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('observarTareas ordena por id descendente', () async {
    await database.insertarTarea('Tarea anterior');
    await database.insertarTarea('Tarea reciente');

    final tareas = await database.observarTareas().first;

    expect(tareas.map((tarea) => tarea.titulo).toList(), [
      'Tarea reciente',
      'Tarea anterior',
    ]);
  });

  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('Guarda y muestra una tarea recién agregada', (tester) async {
    await tester.pumpWidget(GestorTareasApp(database: database));
    await tester.enterText(find.byType(TextField), 'Probar Drift');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Probar Drift'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
