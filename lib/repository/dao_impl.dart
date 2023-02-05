import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/repository/dao.dart';
import 'package:sqflite/sqflite.dart';

class DAOImpl extends DAO {
  DAOImpl(super.futureDatabase);

  @override
  Future<void> saveAsFavorite(Movie movie) async {
    if (movie.isFavorite) return;

    movie.isFavorite = true;

    var database = await futureDatabase;

    database.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteFavorite(int id) async {
    var database = await futureDatabase;

    database.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
