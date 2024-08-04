import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/incidencias.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(IncidenciaAdapter()); // Registrar el adaptador
  await Hive.openBox<Incidencia>('incidencias'); // Abrir la caja de Hive
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supervisión Escolar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
