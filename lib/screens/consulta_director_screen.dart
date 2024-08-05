import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaDirectorScreen extends StatefulWidget {
  @override
  _ConsultDirectorScreenState createState() => _ConsultDirectorScreenState();
}

class _ConsultDirectorScreenState extends State<ConsultaDirectorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  Map<String, dynamic>? _directorDetails;

  Future<void> fetchDirectorDetails(String id) async {
    final response = await http
        .get(Uri.parse('https://adamix.net/minerd/def/registro.php/$id'));

    if (response.statusCode == 200) {
      setState(() {
        _directorDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load director details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consulta de Director')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'Cédula del Director'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la cédula del director' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    fetchDirectorDetails(_idController.text);
                  }
                },
                child: Text('Buscar'),
              ),
              SizedBox(height: 20),
              if (_directorDetails != null) ...[
                _directorDetails!['photo_url'] != null
                    ? Image.network(
                        _directorDetails!['photo_url'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Text('No hay foto disponible'),
                SizedBox(height: 10),
                Text('Nombre: ${_directorDetails!['name']}'),
                Text('Apellido: ${_directorDetails!['surname']}'),
                Text('Fecha de Nacimiento: ${_directorDetails!['dob']}'),
                Text('Dirección: ${_directorDetails!['address']}'),
                Text('Teléfono: ${_directorDetails!['phone']}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
