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
      subtitle: Text(incidencia.fecha.toIso8601String()),
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
