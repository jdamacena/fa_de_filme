import 'package:english_words/english_words.dart';
import 'package:fa_de_filme/pages/details_page.dart';
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
  final _moviesSuggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

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
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            // prototypeItem: ListTile(
            //   title: Text(
            //     "",
            //     style: _biggerFont,
            //   ),
            // ),
            itemBuilder: ((context, i) {
              /* TODO the divider is conflicting with prototypeItem,
                  it's getting it's height changed along with the other items */
              if (i.isOdd) return const Divider();

              final index = i ~/ 2;
              if (index >= _moviesSuggestions.length) {
                _moviesSuggestions.addAll(generateWordPairs().take(10));
              }

              var name = _moviesSuggestions[index].asPascalCase;

              return ListTile(
                title: Text(
                  name,
                  style: _biggerFont,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(title: name),
                    ),
                  );
                },
              );
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFavorites,
        tooltip: 'Open Favorites',
        child: const Icon(Icons.bookmark),
      ),
    );
  }
}
