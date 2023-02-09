import 'package:fa_de_filme/models/movie.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  const DAO(Future<Database> futureDatabase);

  Future<void> saveAsFavorite(Movie movie);

  Future<void> deleteFavorite(int id);

  Future<List<Movie>> listFavoriteMovies();

  Future<bool> isFavorite(int id);
}
