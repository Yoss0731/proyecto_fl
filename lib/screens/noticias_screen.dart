import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> _news;

  @override
  void initState() {
    super.initState();
    _news = fetchNews();
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(
        Uri.parse('https://remolacha.net/wp-json/wp/v2/posts?search=miner'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noticias')),
      body: FutureBuilder<List<dynamic>>(
        future: _news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay noticias disponibles'));
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final article = news[index];
                return ListTile(
                  title: Text(article['title']['rendered']),
                  subtitle: Text(article['excerpt']['rendered']),
                  onTap: () {
                    // Navegar a detalle de noticia
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
