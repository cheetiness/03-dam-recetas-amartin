class Resena {
  final int? id;
  final int recetaId; 
  final int calificacion; 
  final String comentario;
  final DateTime fecha;

  const Resena({
    this.id,
    required this.recetaId,
    required this.calificacion,
    required this.comentario,
    required this.fecha,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'receta_id': recetaId,
      'calificacion': calificacion,
      'comentario': comentario,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Resena.fromMap(Map<String, Object?> mapa) {
    return Resena(
      id: mapa['id'] as int?,
      recetaId: mapa['receta_id'] as int,
      calificacion: mapa['calificacion'] as int,
      comentario: mapa['comentario'] as String,
      fecha: DateTime.parse(mapa['fecha'] as String),
    );
  }
}
