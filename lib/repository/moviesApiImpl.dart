import 'dart:convert';

import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:fa_de_filme/repository/moviesApi.dart';
import 'package:fa_de_filme/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoviesApiImpl extends MoviesApi {
  @override
  Future<MoviesListResponse> getNowPlaying(int pageKey) async {
    Uri url = Uri.parse(Constants.movieBaseUrl);

    url = url.replace(
      path: '3/movie/now_playing',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY']!,
        'include_adult': 'false',
        'language': 'pt-BR',
        'page': '$pageKey',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var listResponse = MoviesListResponse.fromJson(jsonDecode(response.body));

      return MoviesListResponse(
        page: listResponse.page,
        totalPages: listResponse.totalPages,
        totalResults: listResponse.totalResults,
        results: listResponse.results.map((movie) {
          movie.posterPath = Constants.imageBaseUrl + movie.posterPath;
          return movie;
        }).toList(),
      );
    } else {
      throw Exception('Erro ao carregar filmes');
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    Uri url = Uri.parse(Constants.movieBaseUrl);

    url = url.replace(
      path: '3/movie/$movieId',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY']!,
        'language': 'pt-BR',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var movie = Movie.fromJson(jsonDecode(response.body));

      movie.posterPath = Constants.imageBaseUrl + movie.posterPath;

      return movie;
    } else {
      throw Exception('Erro ao carregar filmes');
    }
  }
}
