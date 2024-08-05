import 'package:flutter/material.dart';
import 'tipos_visitas_screen.dart';
import 'consulta_escuela_screen.dart';
import 'consulta_director_screen.dart';
import 'registrar_visitas_screen.dart';
import 'visitas_registradas_screen.dart';
import 'mapa_visitas_screen.dart';
import 'noticias_screen.dart';
import 'estado_clima_screen.dart';
import 'horoscopo_screen.dart';
import 'video_demostrativo_screen.dart';

class MenuTecnicosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú de Técnicos')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tipos de Visitas'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TiposVisitasScreen()));
            },
          ),
          ListTile(
            title: Text('Consulta de Escuela por Código'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConsultaEscuelaScreen()));
            },
          ),
          ListTile(
            title: Text('Consulta de Director por Cédula'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConsultaDirectorScreen()));
            },
          ),
          ListTile(
            title: Text('Registrar Visita'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrarVisitaScreen()));
            },
          ),
          ListTile(
            title: Text('Visitas Registradas'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => visitas_registradas_screen()));
            },
          ),
          ListTile(
            title: Text('Mapa de Visitas'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VisitsMapScreen()));
            },
          ),
          ListTile(
            title: Text('Noticias'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewsScreen()));
            },
          ),
          ListTile(
            title: Text('Estado del Clima'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()));
            },
          ),
          ListTile(
            title: Text('Horóscopo'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HoroscopoScreen()));
            },
          ),
          ListTile(
            title: Text('Video Demostrativo'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DemoVideoScreen()));
            },
          ),
        ],
      ),
    );
  }
}
