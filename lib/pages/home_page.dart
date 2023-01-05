import 'package:fa_de_filme/pages/favorites_page.dart';
import 'package:flutter/material.dart';

/// Página inicial do app
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FavoritesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Filmes em Cartaz no Momento',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFavorites,
        tooltip: 'Increment',
        child: const Icon(Icons.bookmark),
      ),
    );
  }
}
