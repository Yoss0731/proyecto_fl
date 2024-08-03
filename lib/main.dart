import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'database/incidencias.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Incidencias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IncidenciasPage(),
    );
  }
}

class IncidenciasPage extends StatefulWidget {
  @override
  _IncidenciasPageState createState() => _IncidenciasPageState();
}

class _IncidenciasPageState extends State<IncidenciasPage> {
  final dbHelper = DatabaseHelper();
  List<String> tiposVisitas = [];

  @override
  void initState() {
    super.initState();
    obtenerTiposDeVisitas(); // Obtener tipos de visitas al iniciar
  }

  Future<void> _addIncidencia() async {
    final incidencia = Incidencia(
      titulo: 'Título de prueba',
      centroEducativo: 'Centro Educativo X',
      regional: 'Regional X',
      distrito: 'Distrito X',
      fecha: DateTime.now(),
      descripcion: 'Descripción de prueba',
      foto: null, // Aquí podrías colocar una ruta de imagen
      audio: null, // Aquí podrías colocar una ruta de audio
    );
    await dbHelper.insertIncidencia(incidencia);
    setState(() {}); // Refrescar la UI para mostrar el cambio
  }

  Future<List<Incidencia>> _getIncidencias() async {
    return await dbHelper.getIncidencias();
  }

  Future<void> _deleteAllIncidencias() async {
    await dbHelper.deleteAllIncidencias();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todos los registros han sido eliminados.')),
    );
  }

  Future<void> obtenerTiposDeVisitas() async {
    final url = Uri.parse('https://adamix.net/minerd/api/tipos_visitas');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tiposVisitas =
              List<String>.from(data['tipos'].map((tipo) => tipo['nombre']));
        });
      } else {
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> mostrarDetallesEscuela(String codigo) async {
    final url = Uri.parse('https://adamix.net/minerd/api/escuelas/$codigo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Mostrar detalles de la escuela, por ejemplo, en un diálogo
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Detalles de la Escuela'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nombre: ${data['nombre']}'),
                Text('Dirección: ${data['direccion']}'),
                Text('Teléfono: ${data['telefono']}'),
                // Añadir más detalles según sea necesario
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cerrar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllIncidencias,
            tooltip: 'Eliminar todos los registros',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Incidencia>>(
              future: _getIncidencias(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final incidencias = snapshot.data!;
                return ListView.builder(
                  itemCount: incidencias.length,
                  itemBuilder: (context, index) {
                    final incidencia = incidencias[index];
                    return ListTile(
                      title: Text(incidencia.titulo),
                      subtitle: Text(incidencia.descripcion),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Reemplazar con un código de escuela real
              await mostrarDetallesEscuela('codigo_de_ejemplo');
            },
            child: Text('Mostrar Detalles Escuela'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIncidencia,
        child: Icon(Icons.add),
      ),
    );
  }
}
