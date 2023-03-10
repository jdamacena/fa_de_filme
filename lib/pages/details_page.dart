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
  late MoviesRepository _moviesRepository;

  @override
  void initState() {
    super.initState();

    _movie = widget.movie;
    _moviesRepository = getIt.get<MoviesRepository>();
    _moviesRepository
        .isFavorite(_movie.id)
        .then((value) => setState(() {
          _movie.isFavorite = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: _moviesRepository.getMovieDetails(_movie.id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          _movie = snapshot.data!
            ..isFavorite = _movie.isFavorite;

          return getPageContent(_movie);
        } else if (snapshot.hasError) {
          return getPageContent(
            _movie,
            error:
                "Algumas informações não puderam ser carregadas, verifique sua conexão com a internet.",
          );
        }

        // By default, show the movie info received from the list.
        return getPageContent(_movie);
      },
    );
  }

  /// Fills the page with movie information
  Widget getPageContent(Movie movie, {String? error}) {
    var inputDate = DateTime.parse(movie.releaseDate);
    var outputFormat = DateFormat('dd/MM/yyyy');

    String formattedReleaseDate = outputFormat.format(inputDate);

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
                await _moviesRepository.saveAsFavorite(movie);
                setState(() {
                  _movie.isFavorite = true;
                });
              },
            )
          else
            IconButton(
              tooltip: "Remover Favorito",
              icon: const Icon(
                Icons.bookmark,
              ),
              onPressed: () async {
                await _moviesRepository.deleteFavorite(movie.id);

                setState(() {
                  _movie.isFavorite = false;
                });
              },
            ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_movie);
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
