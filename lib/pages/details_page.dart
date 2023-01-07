import 'dart:convert';

import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    _futureMovie = fetchMovie(_movie.id);
  }

  Future<Movie> fetchMovie(int movieId) async {
    final response = await http.get(Uri.parse(
        '${Constants.movieBaseUrl}/movie/$movieId?api_key=${Constants.apiKey}&language=pt-BR'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro ao carregar filmes');
    }
  }

  Widget getImageWidget(Movie movie) {
    var imagePath = Constants.imageBaseUrl + movie.posterPath;

    double imgHeight = 208.0;

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Container(
          height: imgHeight,
          child: Image.network(
            imagePath,
            height: imgHeight,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var movie = _movie;

    var testView = FutureBuilder<Movie>(
      future: _futureMovie,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _movie = snapshot.data!;

          movie = _movie;

          return getPageContent(movie);
        } else if (snapshot.hasError) {
          return getPageContent(movie,
              error:
                  "Algumas informações não puderam ser carregadas, verifique sua conexão com a internet.");
        }

        // By default, show the movie info received from the list.
        return getPageContent(
          movie,
        );
      },
    );

    return testView;
  }

  /// Fills the page with movie information
  Widget getPageContent(Movie movie, {String? error}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            tooltip: "Favoritar",
            icon: const Icon(
              Icons.bookmark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: getImageWidget(movie),
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
                        Text("Data de lançamento: ${movie.releaseDate}"),
                        Text("Duração: ${(movie.runtime >= 0) ? "${movie.runtime} min." : "-"}"),
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
    );
  }
}
