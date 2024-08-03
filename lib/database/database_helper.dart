import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'incidencias.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'incidencias.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incidencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        centroEducativo TEXT,
        regional TEXT,
        distrito TEXT,
        fecha TEXT,
        descripcion TEXT,
        foto TEXT,
        audio TEXT
      )
    ''');
  }

  // Funciones CRUD
  Future<int> insertIncidencia(Incidencia incidencia) async {
    Database db = await database;
    return await db.insert('incidencias', incidencia.toMap());
  }

  Future<List<Incidencia>> getIncidencias() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incidencias');
    return List.generate(maps.length, (i) {
      return Incidencia.fromMap(maps[i]);
    });
  }

  Future<int> updateIncidencia(Incidencia incidencia) async {
    Database db = await database;
    return await db.update(
      'incidencias',
      incidencia.toMap(),
      where: 'id = ?',
      whereArgs: [incidencia.id],
    );
  }

  Future<int> deleteIncidencia(int id) async {
    Database db = await database;
    return await db.delete(
      'incidencias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllIncidencias() async {
    Database db = await database;
    await db.delete('incidencias');
  }
}
