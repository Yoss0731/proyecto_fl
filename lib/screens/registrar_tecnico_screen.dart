import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha de nacimiento
import 'package:http/http.dart' as http;

class RegistroTecnicoScreen extends StatefulWidget {
  @override
  _RegistroTecnicoScreenState createState() => _RegistroTecnicoScreenState();
}

class _RegistroTecnicoScreenState extends State<RegistroTecnicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _claveController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  DateTime? _fechaNacimiento;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('https://adamix.net/minerd/def/registro.php');
      var response = await http.post(uri, body: {
        'cedula': _cedulaController.text,
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'clave': _claveController.text,
        'correo': _correoController.text,
        'telefono': _telefonoController.text,
        'fecha_nacimiento': _fechaNacimiento != null
            ? DateFormat('yyyy-MM-dd').format(_fechaNacimiento!)
            : '',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registro exitoso')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Técnico')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(labelText: 'Cédula'),
                validator: (value) =>
                    value!.isEmpty ? 'El campo cedula es requerido' : null,
              ),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'El campo nombre es requerido' : null,
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'El campo apellido es requerido' : null,
              ),
              TextFormField(
                controller: _claveController,
                decoration: InputDecoration(labelText: 'Clave'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'El campo clave es requerido' : null,
              ),
              TextFormField(
                controller: _correoController,
                decoration: InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'El campo correo es requerido' : null,
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'El campo telefono es requerido' : null,
              ),
              SizedBox(height: 16),
              Text('Fecha de Nacimiento'),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _fechaNacimiento) {
                    setState(() {
                      _fechaNacimiento = pickedDate;
                    });
                  }
                },
                child: Text(_fechaNacimiento != null
                    ? DateFormat('yyyy-MM-dd').format(_fechaNacimiento!)
                    : 'Seleccionar Fecha'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Registrar Técnico'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
