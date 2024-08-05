import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class visitas_registradas_screen extends StatefulWidget {
  @override
  _RegisteredVisitsScreenState createState() => _RegisteredVisitsScreenState();
}

class _RegisteredVisitsScreenState extends State<visitas_registradas_screen> {
  late Future<List<dynamic>> _visits;

  @override
  void initState() {
    super.initState();
    _visits = fetchVisits();
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<List<dynamic>> fetchVisits() async {
    final response = await http
        .get(Uri.parse('https://adamix.net/minerd/def/situaciones.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load visits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitas Registradas')),
      body: FutureBuilder<List<dynamic>>(
        future: _visits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay visitas registradas'));
          } else {
            final visits = snapshot.data!;
            return ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final visit = visits[index];
                return ListTile(
                  title: Text('Código: ${visit['school_code']}'),
                  subtitle: Text('Motivo: ${visit['reason']}'),
                  onTap: () {
                    // Navegar a detalle de visita
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
