import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/repository/datasources/dao.dart';
import 'package:sqflite/sqflite.dart';

class DAOImpl extends DAO {
  final Future<Database> futureDatabase;

  DAOImpl(this.futureDatabase) : super(futureDatabase);

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

  @override
  Future<List<Movie>> listFavoriteMovies() async {
    var database = await futureDatabase;

    final List<Map<String, dynamic>> maps = await database.query('favorites');

    var list = List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        runtime: maps[i]['runtime'],
        overview: maps[i]['overview'],
        posterPath: maps[i]['poster_path'],
        isFavorite: (maps[i]['is_favorite'] as num) == 1,
        releaseDate: maps[i]['release_date'],
        voteAverage: maps[i]['vote_average'],
      );
    });

    list.sort((a, b) => a.title.compareTo(b.title));

    return list;
  }

  @override
  Future<bool> isFavorite(int id) async {
    var database = await futureDatabase;

    final List<Map<String, dynamic>> maps = await database.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty;
  }
}
