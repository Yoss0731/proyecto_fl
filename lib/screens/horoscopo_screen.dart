import 'package:flutter/material.dart';

class HoroscopoScreen extends StatefulWidget {
  @override
  _HoroscopoScreenState createState() => _HoroscopoScreenState();
}

class _HoroscopoScreenState extends State<HoroscopoScreen> {
  String? _selectedSigno;
  final Map<String, String> _horoscopos = {
    'Aries':
        'Hoy es un buen día para liderar. Tu energía es alta y estás listo para nuevos desafíos.',
    'Tauro':
        'Es un día para enfocarte en tus finanzas. La estabilidad económica es clave.',
    'Géminis':
        'Tu creatividad está en su punto más alto. Aprovecha para explorar nuevas ideas.',
    'Cáncer':
        'Hoy es un buen día para centrarte en tu hogar y tus seres queridos.',
    'Leo':
        'La confianza está de tu lado. Es un buen momento para destacar en el trabajo.',
    'Virgo':
        'La organización es clave hoy. Planifica y trabaja en proyectos a largo plazo.',
    'Libra':
        'Busca el equilibrio en tus relaciones. Es un buen momento para resolver conflictos.',
    'Escorpio':
        'Tu intuición está fuerte. Confía en tus corazonadas y toma decisiones basadas en ellas.',
    'Sagitario':
        'Es un buen día para la aventura y explorar nuevas oportunidades.',
    'Capricornio':
        'La paciencia será tu mejor aliada. Enfócate en tus metas a largo plazo.',
    'Acuario':
        'Tu visión innovadora te ayudará a resolver problemas de manera creativa.',
    'Piscis':
        'Tu empatía está en su punto máximo. Es un buen momento para ayudar a los demás.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horóscopo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu signo zodiacal:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text('Selecciona tu signo'),
              value: _selectedSigno,
              items: _horoscopos.keys.map((signo) {
                return DropdownMenuItem<String>(
                  value: signo,
                  child: Text(signo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSigno = value;
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedSigno != null)
              Text(
                'Horóscopo para $_selectedSigno:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            if (_selectedSigno != null) SizedBox(height: 20),
            if (_selectedSigno != null)
              Text(
                _horoscopos[_selectedSigno!]!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
