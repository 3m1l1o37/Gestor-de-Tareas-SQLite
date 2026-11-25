String? validarTitulo(String? titulo) {
  final tituloNormalizado = (titulo ?? '').trim();

  if (tituloNormalizado.isEmpty) {
    return 'Escribe un título para la tarea.';
  }
  if (tituloNormalizado.length > 200) {
    return 'El título no puede superar los 200 caracteres.';
  }

  return null;
}
