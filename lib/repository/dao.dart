import 'package:fa_de_filme/models/movie.dart';
import 'package:sqflite/sqflite.dart';

abstract class DAO {
  final Future<Database> futureDatabase;

  const DAO(this.futureDatabase);

  Future<void> saveAsFavorite(Movie movie);

  Future<void> deleteFavorite(int id);
}
