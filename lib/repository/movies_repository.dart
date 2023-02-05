import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:fa_de_filme/repository/datasources/dao.dart';
import 'package:fa_de_filme/repository/datasources/movies_api.dart';

abstract class MoviesRepository {
  MoviesRepository(DAO dao, MoviesApi moviesApi);

  Future<Movie> getMovieDetails(int movieId);

  Future<void> saveAsFavorite(Movie movie);

  Future<void> deleteFavorite(int id);

  Future<MoviesListResponse> getNowPlaying(int pageKey);

  Future<List<Movie>> listFavoriteMovies();
}
