import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Técnico ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/YO.jpg'),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre: Yosser Batista'),
                    Text('Matrícula: 2022-0199'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Técnico 2',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Diego.jpg'),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre: Miguel Torres'),
                    Text('Matrícula: 2022-0491'),
                    // Puedes agregar más detalles si es necesario
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Reflexión:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              '“La educación es el arma más poderosa que puedes usar para cambiar el mundo.” – Nelson Mandela',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
