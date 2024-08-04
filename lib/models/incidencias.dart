import 'package:hive/hive.dart';

part 'incidencias.g.dart';

@HiveType(typeId: 0) // Usa un typeId único para cada tipo de modelo
class Incidencia extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final String centroEducativo;

  @HiveField(3)
  final String regional;

  @HiveField(4)
  final String distrito;

  @HiveField(5)
  final DateTime fecha;

  @HiveField(6)
  final String descripcion;

  @HiveField(7)
  final String? foto;

  @HiveField(8)
  final String? audio;

  Incidencia({
    required this.id,
    required this.titulo,
    required this.centroEducativo,
    required this.regional,
    required this.distrito,
    required this.fecha,
    required this.descripcion,
    this.foto,
    this.audio,
  });

  // Método para convertir un mapa a un objeto Incidencia
  factory Incidencia.fromMap(Map<String, dynamic> map) {
    return Incidencia(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      centroEducativo: map['centroEducativo'] as String,
      regional: map['regional'] as String,
      distrito: map['distrito'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
      descripcion: map['descripcion'] as String,
      foto: map['foto'] as String?,
      audio: map['audio'] as String?,
    );
  }

  // Método para convertir un objeto Incidencia a un mapa
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
}
