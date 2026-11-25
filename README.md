# gestor_tareas_local

Aplicación Flutter multiplataforma para la gestión local de tareas.

## Tecnología de persistencia elegida

Se eligió **Drift** porque permite describir el esquema de la base de datos con
tipos Dart, generar código y trabajar con SQLite con seguridad de tipos. **Drift
Flutter** integra la apertura de la base de datos con Flutter y gestiona su
almacenamiento en las plataformas compatibles, incluida web; por eso no hace
falta añadir `path_provider` directamente.

La tabla `Tareas` tiene este esquema:

| Columna | Tipo y restricciones |
| --- | --- |
| `id` | Entero, llave primaria autoincremental |
| `titulo` | Texto de 1 a 200 caracteres |
| `completada` | Booleano, valor predeterminado `false` |

Cada registro se identifica de forma única mediante `id`, asignado
automáticamente al insertar una tarea. El título no se usa como identificador,
por lo que puede repetirse.

La base se abre con el nombre `gestor_tareas` y el esquema está en la versión 1.
El código generado se actualiza con:

```shell
dart run build_runner build --delete-conflicting-outputs
```

## Crear y consultar tareas

La aplicación crea una instancia de `AppDatabase` al iniciar y la inyecta en
`TareasPage`. La pantalla guarda títulos con `insertarTarea` y observa la lista
reactivamente mediante `observarTareas`. También permite editar el título,
cambiar el estado y eliminar registros; los títulos se validan y recortan antes
de guardarse.

Para comprobar la persistencia, ejecuta la app, agrega una tarea, ciérrala por
completo y vuelve a abrirla. La tarea debe seguir apareciendo; una recarga en
caliente no equivale a cerrar y reiniciar la aplicación.

## Preparar y ejecutar

Desde la raíz del proyecto:

```shell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Para ejecutar en web con un origen estable:

```shell
flutter run -d chrome --web-port=7357
```

Usa siempre el mismo puerto y host (`localhost:7357`); el almacenamiento web
está asociado al origen y cambiar de puerto o usar `127.0.0.1` crea otro origen.
`pubspec.lock` y `lib/data/app_database.g.dart` están incluidos para reproducir
las dependencias y el código generado. `.gitignore` excluye `/build/`.

## Archivos de soporte web

La [guía oficial de Drift para web](https://drift.simonbinder.eu/platforms/web/)
recomienda descargar los dos archivos compatibles desde el mismo release de
Drift. Para Drift `2.35.4`, se usaron estos activos oficiales:

- [`sqlite3.wasm`](https://github.com/simolus3/drift/releases/download/drift-2.35.4/sqlite3.wasm)
- [`drift_worker.js`](https://github.com/simolus3/drift/releases/download/drift-2.35.4/drift_worker.js)

Ambos van directamente en `web/`. El release `drift-2.35.4` publica el worker
como `drift_worker.js`; ese es el nombre configurado en `DriftWebOptions`.
Aunque algunos ejemplos generales de la documentación muestran
`drift_worker.dart.js`, ese no es el nombre del activo en este release.

El release correspondiente de [`sqlite3.dart` 3.5.2](https://github.com/simolus3/sqlite3.dart/releases/tag/sqlite3-3.5.2)
también publica [`sqlite3.wasm`](https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.5.2/sqlite3.wasm).
Para este proyecto se conserva el par del mismo release de Drift, tal como
recomienda la guía.

## Estado de plataformas (completar al verificar)

Marca una sola columna por plataforma después de probarla:

| Plataforma | Verificada | Solo prevista |
| --- | --- | --- |
| Android | [ ] | [ ] |
| iOS | [ ] | [ ] |
| Windows | [ ] | [ ] |
| Linux | [ ] | [ ] |
| macOS | [ ] | [ ] |
| Web | [ ] | [ ] |

## Cobertura de pruebas

Ejecuta todas las pruebas con `flutter test`:

| Archivo | Qué comprueba |
| --- | --- |
| `test/utils/validacion_test.dart` | Títulos vacíos, solo espacios, válidos y demasiado largos; incluye el límite de 200 caracteres. |
| `test/data/app_database_test.dart` | Inserción y consulta, actualización de título, cambio de estado y eliminación por id. Usa una base en memoria y la cierra en `tearDown`. |
| `test/widget_test.dart` | Presentación inicial y flujos de alta, edición, cambio de estado y eliminación con confirmación. Usa una base en memoria. |
