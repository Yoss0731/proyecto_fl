import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha y hora
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrarVisitaScreen extends StatefulWidget {
  @override
  _RegistrarVisitaScreenState createState() => _RegistrarVisitaScreenState();
}

class _RegistrarVisitaScreenState extends State<RegistrarVisitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _directorIdController = TextEditingController();
  final _schoolCodeController = TextEditingController();
  final _commentController = TextEditingController();
  late DateTime _date;
  File? _photo;
  String? _audioPath;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _latitude = 0.0; // Default lat
    _longitude = 0.0; // Default long
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/audio_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.m4a';

    setState(() {
      _audioPath = path;
      _isRecording = true;
    });

    await _recorder.startRecorder(
      toFile: _audioPath,
      codec: Codec.aacADTS,
    );
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _submitVisit() async {
    if (_formKey.currentState!.validate()) {
      final uri =
          Uri.parse('https://adamix.net/minerd/minerd/registrar_visita.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields['director_id'] = _directorIdController.text;
      request.fields['school_code'] = _schoolCodeController.text;
      request.fields['comment'] = _commentController.text;
      request.fields['date'] = _date.toIso8601String();
      request.fields['latitude'] = _latitude.toString();
      request.fields['longitude'] = _longitude.toString();

      if (_photo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _photo!.path));
      }

      if (_audioPath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('audio', _audioPath!));
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Visita registrada con éxito')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al registrar la visita')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Visita')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _directorIdController,
                decoration: InputDecoration(labelText: 'Cédula del Director'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la cédula del director' : null,
              ),
              TextFormField(
                controller: _schoolCodeController,
                decoration: InputDecoration(labelText: 'Código del Centro'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el código del centro' : null,
              ),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(labelText: 'Comentario'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Adjuntar Foto'),
              ),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                child: Text(
                    _isRecording ? 'Detener Grabación' : 'Grabar Nota de Voz'),
              ),
              if (_audioPath != null)
                ElevatedButton(
                  onPressed: () {
                    // Implementar la lógica de reproducción aquí si es necesario
                  },
                  child: Text('Reproducir Nota de Voz'),
                ),
              SizedBox(height: 20),
              Text('Fecha: ${DateFormat('yyyy-MM-dd').format(_date)}'),
              Text('Hora: ${DateFormat('HH:mm:ss').format(_date)}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitVisit,
                child: Text('Registrar Visita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
