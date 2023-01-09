import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
  late Future<Database> _database;

  @override
  void initState()  {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    initDatabase();

    _movie = widget.movie;
    _futureMovie = fetchMovie(_movie.id);
  }

  Future<void> initDatabase() async {
    _database = openDatabase(join(await getDatabasesPath(), Constants.databaseName));
  }

  /// Get a movie's details from the internet
  Future<Movie> fetchMovie(int movieId) async {
    final url = Uri(
      scheme: 'https',
      host: Constants.movieBaseUrl,
      path: '3/movie/$movieId',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY']!, // read it here
        'language': 'pt-BR',
      },
    );

    final response = await http.get(url);

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

  /// Save a movie in the local database
  Future<void> saveAsFavorite(Movie movie) async {
    final db = await _database;

    if (!movie.isFavorite) {
      movie.isFavorite = true;

      await db.insert(
        'favorites',
        movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Delete a movie from the local database
  Future<void> deleteFavorite(int id) async {
    final db = await _database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Widget getImageWidget(Movie movie) {
    var imagePath = Constants.imageBaseUrl + movie.posterPath;

    double imgHeight = 208.0;

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: SizedBox(
          height: imgHeight,
          child: CachedNetworkImage(
            imageUrl: imagePath,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.image),
            height: imgHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          if(!movie.isFavorite)
          IconButton(
            tooltip: "Favoritar",
            icon: const Icon(
              Icons.bookmark_border,
            ),
            onPressed: () async {
              await saveAsFavorite(movie);
              setState(() {});
            },
          ) else IconButton(
            tooltip: "Remover Favorito",
            icon: const Icon(
              Icons.bookmark,
            ),
            onPressed: () async {
              await deleteFavorite(movie.id);

              setState(() {
                movie.isFavorite = false;
              });
            },
          ) ,
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
                        Text("Data de lançamento: $formattedReleaseDate"),
                        Text("Duração: ${(movie.runtime > 0) ? getFormattedRuntime(movie.runtime) : "-"}"),
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

  String getFormattedRuntime(int runtime) {
    var hours = runtime ~/ 60;
    var minutes = runtime - (hours * 60);

    String formattedDuration = "${hours}h ${minutes.toString().padLeft(2, '0')}m";

    return formattedDuration;
  }
}
