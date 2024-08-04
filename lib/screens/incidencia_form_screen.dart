import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/incidencias.dart';
import '../database/database_helper.dart';

class IncidenciaFormScreen extends StatefulWidget {
  final int? initialId;

  IncidenciaFormScreen({this.initialId});

  @override
  _IncidenciaFormScreenState createState() => _IncidenciaFormScreenState();
}

class _IncidenciaFormScreenState extends State<IncidenciaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late int id;
  String titulo = '';
  String centroEducativo = '';
  String regional = '';
  String distrito = '';
  DateTime fecha = DateTime.now();
  String descripcion = '';
  File? foto;
  File? audio;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    id = widget.initialId ?? _generateNewId();
  }

  Future<void> _initDatabase() async {
    await _databaseHelper.init();
  }

  int _generateNewId() {
    // Lógica para generar un nuevo ID único
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        foto = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newIncidencia = Incidencia(
        id: id,
        titulo: titulo,
        centroEducativo: centroEducativo,
        regional: regional,
        distrito: distrito,
        fecha: fecha,
        descripcion: descripcion,
        foto: foto?.path,
        audio: audio?.path,
      );

      try {
        await _databaseHelper.addIncidencia(newIncidencia);
        Navigator.of(context).pop(true); // Retorna a la pantalla anterior
      } catch (e) {
        // Manejar el error en caso de fallo al guardar
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Hubo un problema al guardar la incidencia: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Incidencia')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                onSaved: (value) => titulo = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, ingrese un título' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Centro Educativo'),
                onSaved: (value) => centroEducativo = value ?? '',
                validator: (value) => value!.isEmpty
                    ? 'Por favor, ingrese el centro educativo'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Regional'),
                onSaved: (value) => regional = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, ingrese la regional' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Distrito'),
                onSaved: (value) => distrito = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, ingrese el distrito' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                onSaved: (value) => descripcion = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, ingrese la descripción' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Foto'),
              ),
              if (foto != null) Image.file(foto!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Guardar Incidencia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
