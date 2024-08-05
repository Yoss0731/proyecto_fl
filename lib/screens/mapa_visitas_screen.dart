import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class VisitsMapScreen extends StatefulWidget {
  @override
  _VisitsMapScreenState createState() => _VisitsMapScreenState();
}

class _VisitsMapScreenState extends State<VisitsMapScreen> {
  late GoogleMapController _mapController;
  late Future<List<dynamic>> _visits;
  LatLng _center = LatLng(0, 0); // Posición inicial del mapa

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
    try {
      final response = await http
          .get(Uri.parse('https://adamix.net/minerd/def/situaciones.php'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return json.decode(response.body);
        } catch (e) {
          print('Error al parsear JSON: $e');
          throw Exception('Error al parsear JSON');
        }
      } else {
        throw Exception('Failed to load visits');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      throw Exception('Error en la solicitud');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapCenter();
  }

  void _updateMapCenter() async {
    final visits = await _visits;
    if (visits.isNotEmpty) {
      final latitudes =
          visits.map((visit) => visit['latitude'] as double).toList();
      final longitudes =
          visits.map((visit) => visit['longitude'] as double).toList();
      final centerLat = (latitudes.reduce((a, b) => a + b) / latitudes.length);
      final centerLng =
          (longitudes.reduce((a, b) => a + b) / longitudes.length);
      setState(() {
        _center = LatLng(centerLat, centerLng);
      });
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Visitas')),
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
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 2,
              ),
              markers: visits.map((visit) {
                return Marker(
                  markerId: MarkerId(visit['id'].toString()),
                  position: LatLng(visit['latitude'], visit['longitude']),
                  infoWindow: InfoWindow(
                    title: visit['school_code'],
                    snippet: visit['reason'],
                    onTap: () {
                      // Aquí puedes manejar la acción al tocar el infoWindow
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitDetailScreen(
                              visitId: visit['id'].toString()),
                        ),
                      );
                    },
                  ),
                );
              }).toSet(),
            );
          }
        },
      ),
    );
  }
}

class VisitDetailScreen extends StatelessWidget {
  final String visitId;

  VisitDetailScreen({required this.visitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Visita'),
      ),
      body: Center(
        child: Text('Detalles de la visita: $visitId'),
        // Aquí deberías agregar la lógica para mostrar detalles reales
      ),
    );
  }
}
