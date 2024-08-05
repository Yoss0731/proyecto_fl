import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'registrar_tecnico_screen.dart'; // Importa la pantalla de registro de técnicos
import 'menu_tecnicos_screen.dart'; // Importa la pantalla del menú de técnicos

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController();
  final _claveController = TextEditingController();

  Future<void> _login() async {
    if (_cedulaController.text.isEmpty || _claveController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El campo cédula y clave son requeridos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://adamix.net/minerd/def/iniciar_sesion.php'),
        body: {
          'cedula': _cedulaController.text,
          'clave': _claveController.text,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Verificar si la autenticación fue exitosa
        if (responseData.containsKey('exito') &&
            responseData['exito'] == true) {
          // Redirigir al menú de técnicos si las credenciales son correctas
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuTecnicosScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Credenciales incorrectas')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la conexión')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la conexión')),
      );
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(labelText: 'Cédula'),
            ),
            TextField(
              controller: _claveController,
              decoration: InputDecoration(labelText: 'Clave'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistroTecnicoScreen()),
                );
              },
              child: Text('Registrar nuevo técnico'),
            ),
          ],
        ),
      ),
    );
  }
}
