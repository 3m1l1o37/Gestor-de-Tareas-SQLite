import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart' as app_model;

part 'app_database.g.dart';

@DataClassName('TareaDb')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titulo => text().withLength(min: 1, max: 200)();

  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'gestor_tareas'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<int> insertarTarea(String titulo) {
    return into(tareas).insert(TareasCompanion.insert(titulo: titulo));
  }

  Future<int> actualizarTitulo(int id, String titulo) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(titulo: Value(titulo)),
    );
  }

  Future<int> cambiarEstado(int id, bool completada) {
    return (update(tareas)..where((tarea) => tarea.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  Future<int> eliminarTarea(int id) {
    return (delete(tareas)..where((tarea) => tarea.id.equals(id))).go();
  }

  Stream<List<app_model.Tarea>> observarTareas() {
    final consulta = select(tareas)
      ..orderBy([(tarea) => OrderingTerm.desc(tarea.id)]);

    return consulta.watch().map(
      (tareas) => tareas
          .map(
            (tarea) => app_model.Tarea(
              id: tarea.id,
              titulo: tarea.titulo,
              completada: tarea.completada,
            ),
          )
          .toList(),
    );
  }
}
