import 'package:flutter/material.dart';
import '../models/incidencias.dart';
import 'dart:io';

class IncidenciaDetailScreen extends StatelessWidget {
  final Incidencia incidencia;

  IncidenciaDetailScreen({required this.incidencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(incidencia.titulo)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Centro Educativo: ${incidencia.centroEducativo}'),
            Text('Regional: ${incidencia.regional}'),
            Text('Distrito: ${incidencia.distrito}'),
            Text(
                'Fecha: ${incidencia.fecha.toLocal().toString().split(' ')[0]}'),
            Text('Descripción: ${incidencia.descripcion}'),
            SizedBox(height: 16),
            if (incidencia.foto != null) Image.file(File(incidencia.foto!)),
            // Aquí se puede agregar un reproductor de audio si es necesario
          ],
        ),
      ),
    );
  }
}
