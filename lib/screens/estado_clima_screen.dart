import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  Map<String, dynamic>? _weatherDetails;
  bool _loading = false;

  Future<void> fetchWeather(double lat, double lon) async {
    final apiKey = '9fa5e7ef4f83faa59826446871618a02';
    final url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,daily,alerts&appid=$apiKey&units=metric';

    setState(() {
      _loading = true;
    });

    final response = await http.get(Uri.parse(url));

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _weatherDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estado del Clima')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _latController,
                decoration: InputDecoration(labelText: 'Latitud'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la latitud' : null,
              ),
              TextFormField(
                controller: _lonController,
                decoration: InputDecoration(labelText: 'Longitud'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la longitud' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    fetchWeather(
                      double.parse(_latController.text),
                      double.parse(_lonController.text),
                    );
                  }
                },
                child: Text('Consultar Clima'),
              ),
              SizedBox(height: 20),
              if (_loading) CircularProgressIndicator(),
              if (_weatherDetails != null && !_loading) ...[
                Text('Temperatura: ${_weatherDetails!['current']['temp']} °C'),
                Text(
                    'Descripción: ${_weatherDetails!['current']['weather'][0]['description']}'),
                Text('Humedad: ${_weatherDetails!['current']['humidity']}%'),
                Text(
                    'Viento: ${_weatherDetails!['current']['wind_speed']} m/s'),
                // Agrega más detalles si es necesario
              ],
            ],
          ),
        ),
      ),
    );
  }
}
