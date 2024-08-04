// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incidencias.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncidenciaAdapter extends TypeAdapter<Incidencia> {
  @override
  final int typeId = 0;

  @override
  Incidencia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Incidencia(
      id: fields[0] as int,
      titulo: fields[1] as String,
      centroEducativo: fields[2] as String,
      regional: fields[3] as String,
      distrito: fields[4] as String,
      fecha: fields[5] as DateTime,
      descripcion: fields[6] as String,
      foto: fields[7] as String?,
      audio: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Incidencia obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.centroEducativo)
      ..writeByte(3)
      ..write(obj.regional)
      ..writeByte(4)
      ..write(obj.distrito)
      ..writeByte(5)
      ..write(obj.fecha)
      ..writeByte(6)
      ..write(obj.descripcion)
      ..writeByte(7)
      ..write(obj.foto)
      ..writeByte(8)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidenciaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
