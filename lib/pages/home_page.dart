import 'package:fa_de_filme/pages/favorites_page.dart';
import 'package:fa_de_filme/widgets/movies_list.dart';
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
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(widget.title),
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: const MoviesListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFavorites,
        tooltip: 'Abrir Favoritos',
        child: const Icon(Icons.bookmark),
      ),
    );
  }
}

