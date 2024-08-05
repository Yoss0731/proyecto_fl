import 'package:flutter/material.dart';

class TiposVisitasScreen extends StatelessWidget {
  // Lista estática de tipos de visitas y descripciones
  final List<VisitType> _exampleVisitTypes = [
    VisitType(
        name: 'Inspección',
        description:
            'Revisión general de las instalaciones y el funcionamiento del centro.'),
    VisitType(
        name: 'Evaluación',
        description:
            'Evaluación del desempeño del personal y la calidad de la educación.'),
    VisitType(
        name: 'Seguimiento',
        description:
            'Visita para seguir el progreso de las recomendaciones anteriores.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tipos de Visitas')),
      body: ListView.builder(
        itemCount: _exampleVisitTypes.length,
        itemBuilder: (context, index) {
          final visitType = _exampleVisitTypes[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(visitType.name),
              subtitle: Text(visitType.description),
            ),
          );
        },
      ),
    );
  }
}

class VisitType {
  final String name;
  final String description;

  VisitType({required this.name, required this.description});
}
