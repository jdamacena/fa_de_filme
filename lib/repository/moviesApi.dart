import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';

abstract class MoviesApi {
  Future<MoviesListResponse> getNowPlaying(int pageKey);

  Future<Movie> getMovieDetails(int movieId);
}
