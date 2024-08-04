import 'dart:io';

import 'package:flutter/material.dart';
import '../models/incidencias.dart';
import '../screens/incidencia_detail_screen.dart';

class IncidenciaTile extends StatelessWidget {
  final Incidencia incidencia;

  IncidenciaTile({required this.incidencia});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(incidencia.titulo),
      subtitle: Text(
          'Centro: ${incidencia.centroEducativo}\nFecha: ${incidencia.fecha.toLocal().toString().split(' ')[0]}'),
      trailing: incidencia.foto != null
          ? Image.file(
              File(incidencia.foto!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                IncidenciaDetailScreen(incidencia: incidencia),
          ),
        );
      },
    );
  }
}
