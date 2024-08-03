class Incidencia {
  final int? id;
  final String titulo;
  final String centroEducativo;
  final String regional;
  final String distrito;
  final DateTime fecha;
  final String descripcion;
  final String? foto;
  final String? audio;

  Incidencia({
    this.id,
    required this.titulo,
    required this.centroEducativo,
    required this.regional,
    required this.distrito,
    required this.fecha,
    required this.descripcion,
    this.foto,
    this.audio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'centroEducativo': centroEducativo,
      'regional': regional,
      'distrito': distrito,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'foto': foto,
      'audio': audio,
    };
  }

  factory Incidencia.fromMap(Map<String, dynamic> map) {
    return Incidencia(
      id: map['id'],
      titulo: map['titulo'],
      centroEducativo: map['centroEducativo'],
      regional: map['regional'],
      distrito: map['distrito'],
      fecha: DateTime.parse(map['fecha']),
      descripcion: map['descripcion'],
      foto: map['foto'],
      audio: map['audio'],
    );
  }
}
