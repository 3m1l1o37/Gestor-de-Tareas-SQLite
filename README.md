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
