import 'package:english_words/english_words.dart';
import 'package:fa_de_filme/widgets/movie_grid_tile.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';
import 'details_page.dart';

/// Página de filmes favoritos
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _moviesSuggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    var moviesList = Container(
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
                  "https://image.tmdb.org/t/p/w500/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg",
              overview:
                  "12 anos depois de explorar Pandora e se juntar aos Na'vi, Jake Sully formou uma família com Neytiri e se estabeleceu entre os clãs do novo mundo. Porém, a paz não durará para sempre.",
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
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
      ),
      body: moviesList,
    );
  }
}
