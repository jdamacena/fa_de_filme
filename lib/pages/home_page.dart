import 'package:english_words/english_words.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/pages/details_page.dart';
import 'package:fa_de_filme/pages/favorites_page.dart';
import 'package:fa_de_filme/widgets/movie_grid_tile.dart';
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
        body: Container(
          color: Colors.deepPurple.withAlpha(220),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: ((context, index) {
              if (index >= _moviesSuggestions.length) {
                _moviesSuggestions.addAll(generateWordPairs().take(10));
              }

              var name = _moviesSuggestions[index].asPascalCase;

              var movieMock = Movie(
                  id: 99,
                  title: name,
                  releaseDate: "09/02/2022",
                  voteAverage: 6.556,
                  posterPath:
                      "https://image.tmdb.org/t/p/w500/65NBNqJiaHeCmqDqkCmrRplJXw.jpg",
                  overview:
                      "Uma jovem extraordinária descobre seu superpoder e convoca a coragem notável, contra todas as probabilidades, para ajudar os outros a mudar suas histórias, ao mesmo tempo em que assume o controle de seu próprio destino. Defendendo o que é certo, ela obteve resultados milagrosos.",
                  runtime: 117);

              return MovieGridTile(
                movie: movieMock,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return DetailsPage(movie: movieMock);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFavorites,
        tooltip: 'Abrir Favoritos',
        child: const Icon(Icons.bookmark),
      ),
    );
  }
}
