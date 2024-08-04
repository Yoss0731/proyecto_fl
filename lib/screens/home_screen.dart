import 'package:flutter/material.dart';
import '../models/incidencias.dart';
import '../database/database_helper.dart';
import 'incidencia_form_screen.dart';
import '../widgets/incidencia_tile.dart';
import '../screens/acerca_de_screen.dart'; // Importa la pantalla Acerca de

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Incidencia>> _incidenciasFuture;

  @override
  void initState() {
    super.initState();
    _refreshIncidencias();
  }

  void _refreshIncidencias() {
    _incidenciasFuture =
        _databaseHelper.getAllIncidencias() as Future<List<Incidencia>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menú'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Acerca de'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Incidencia>>(
        future: _incidenciasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay incidencias registradas'));
          } else {
            final incidencias = snapshot.data!;
            return ListView.builder(
              itemCount: incidencias.length,
              itemBuilder: (context, index) {
                final incidencia = incidencias[index];
                return IncidenciaTile(incidencia: incidencia);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navega a la pantalla de formulario de incidencias
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IncidenciaFormScreen()),
          );
          // Refresca la lista de incidencias si se ha agregado una nueva
          if (result == true) {
            _refreshIncidencias();
            setState(() {});
          }
        },
      ),
    );
  }
}
