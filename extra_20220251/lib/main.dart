import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zelda Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameListScreen(),
    );
  }
}

class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  List<dynamic> _games = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response =
        await http.get(Uri.parse('https://zelda.fanapis.com/api/games'));
    if (response.statusCode == 200) {
      setState(() {
        _games = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  void showGameDetails(dynamic game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zelda Games'),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_games[index]['name']),
            onTap: () => showGameDetails(_games[index]),
          );
        },
      ),
    );
  }
}

class GameDetailsScreen extends StatelessWidget {
  final dynamic game;

  GameDetailsScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(game['description']),
            SizedBox(height: 20),
            Text(
              'Developer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(game['developer']),
            SizedBox(height: 20),
            Text(
              'Publisher:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(game['publisher']),
            SizedBox(height: 20),
            Text(
              'Released Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(game['released_date']),
          ],
        ),
     ),
);
}
}  