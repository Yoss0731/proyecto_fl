import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConsultaEscuelaScreen extends StatefulWidget {
  @override
  _ConsultSchoolScreenState createState() => _ConsultSchoolScreenState();
}

class _ConsultSchoolScreenState extends State<ConsultaEscuelaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  Map<String, dynamic>? _schoolDetails;

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> fetchSchoolDetails(String code) async {
    final response = await http
        .get(Uri.parse('https://adamix.net/minerd/minerd/centros.php/$code'));

    if (response.statusCode == 200) {
      setState(() {
        _schoolDetails = json.decode(response.body);
      });
    } else {
      throw Exception('falla al load school details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consulta de Escuela')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Código de la Escuela'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el código de la escuela' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    fetchSchoolDetails(_codeController.text);
                  }
                },
                child: Text('Buscar'),
              ),
              if (_schoolDetails != null) ...[
                Text('Nombre: ${_schoolDetails!['name']}'),
                Text('Dirección: ${_schoolDetails!['address']}'),
                // Muestra más detalles si es necesario
              ],
            ],
          ),
        ),
      ),
    );
  }
}
