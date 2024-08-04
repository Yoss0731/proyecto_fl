// database/database_helper.dart
import 'package:hive/hive.dart';
import '../models/incidencias.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Box<Incidencia>? _incidenciasBox;

  Future<void> init() async {
    _incidenciasBox = await Hive.openBox<Incidencia>('incidencias');
  }

  Future<void> addIncidencia(Incidencia incidencia) async {
    if (_incidenciasBox != null) {
      await _incidenciasBox!.add(incidencia);
    } else {
      throw Exception('No hay incidencias');
    }
  }

  Future<List<Incidencia>> getAllIncidencias() async {
    if (_incidenciasBox != null) {
      return _incidenciasBox!.values.toList();
    } else {
      throw Exception('No hay incidencias');
    }
  }
}
