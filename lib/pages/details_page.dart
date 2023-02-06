import 'package:fa_de_filme/di/service_locator.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/repository/movies_repository.dart';
import 'package:fa_de_filme/utils/formatter.dart';
import 'package:fa_de_filme/widgets/image_dialog.dart';
import 'package:fa_de_filme/widgets/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Página de detalhes dos filmes
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Movie _movie;
  late Future<Movie> _futureMovie;

  @override
  void initState() {
    super.initState();

    _movie = widget.movie;

    MoviesRepository moviesRepository = getIt.get<MoviesRepository>();
    _futureMovie = moviesRepository.getMovieDetails(_movie.id);
  }

  @override
  Widget build(BuildContext context) {
    var movie = _movie;

    return FutureBuilder<Movie>(
      future: _futureMovie,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _movie = snapshot.data!;

          _movie.isFavorite = movie.isFavorite;

          movie = _movie;

          return getPageContent(movie);
        } else if (snapshot.hasError) {
          return getPageContent(movie,
              error:
                  "Algumas informações não puderam ser carregadas, verifique sua conexão com a internet.");
        }

        // By default, show the movie info received from the list.
        return getPageContent(movie);
      },
    );
  }

  /// Fills the page with movie information
  Widget getPageContent(Movie movie, {String? error}) {
    var inputDate = DateTime.parse(movie.releaseDate);
    var outputFormat = DateFormat('dd/MM/yyyy');

    String formattedReleaseDate = outputFormat.format(inputDate);

    MoviesRepository moviesRepository = getIt.get<MoviesRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          if (!movie.isFavorite)
            IconButton(
              tooltip: "Favoritar",
              icon: const Icon(
                Icons.bookmark_border,
              ),
              onPressed: () async {
                await moviesRepository.saveAsFavorite(movie);
                setState(() {});
              },
            )
          else
            IconButton(
              tooltip: "Remover Favorito",
              icon: const Icon(
                Icons.bookmark,
              ),
              onPressed: () async {
                await moviesRepository.deleteFavorite(movie.id);

                setState(() {
                  movie.isFavorite = false;
                });
              },
            ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(movie);
          return false;
        },
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: PosterImage(
                        imageUrl: movie.posterPath,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => ImageDialog(movie.posterPath),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Data de lançamento: $formattedReleaseDate"),
                          Text("Duração: ${(movie.runtime > 0) ? Formatter.minutesToFormattedDuration(movie.runtime) : "-"}"),
                          Row(
                            children: [
                              Text(
                                  "Nota: ${(movie.voteAverage >= 0) ? movie.voteAverage.toStringAsFixed(2) : "-"}/10"),
                              const Icon(Icons.star, size: 16.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Text(movie.overview),
                  ],
                ),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
