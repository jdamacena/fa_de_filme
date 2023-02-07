import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:fa_de_filme/repository/datasources/dao.dart';
import 'package:fa_de_filme/repository/datasources/movies_api.dart';
import 'package:fa_de_filme/repository/movies_repository.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final DAO dao;
  final MoviesApi moviesApi;

  MoviesRepositoryImpl(this.dao, this.moviesApi) : super(dao, moviesApi);

  @override
  Future<void> deleteFavorite(int id) {
    return dao.deleteFavorite(id);
  }

  @override
  Future<Movie> getMovieDetails(int movieId) {
    return moviesApi.getMovieDetails(movieId);
  }

  @override
  Future<MoviesListResponse> getNowPlaying(int pageKey) {
    return moviesApi.getNowPlaying(pageKey);
  }

  @override
  Future<List<Movie>> listFavoriteMovies() {
    return dao.listFavoriteMovies();
  }

  @override
  Future<void> saveAsFavorite(Movie movie) {
    return dao.saveAsFavorite(movie);
  }

  @override
  Future<bool> isFavorite(int id) {
    return dao.isFavorite(id);
  }
}
