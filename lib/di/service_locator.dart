import 'package:fa_de_filme/repository/datasources/dao.dart';
import 'package:fa_de_filme/repository/datasources/dao_impl.dart';
import 'package:fa_de_filme/repository/datasources/movies_api.dart';
import 'package:fa_de_filme/repository/datasources/movies_api_impl.dart';
import 'package:fa_de_filme/repository/movies_repository.dart';
import 'package:fa_de_filme/repository/movies_repository_impl.dart';
import 'package:fa_de_filme/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  getIt.registerLazySingleton<Future<Database>>(() async =>
    openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites('
          'id INTEGER PRIMARY KEY, '
          'title TEXT, '
          'overview TEXT, '
          'release_date TEXT, '
          'poster_path TEXT, '
          'is_favorite BOOLEAN, '
          'vote_average DOUBLE, '
          'runtime INTEGER)',
        );
      },
      version: 1,
    ),
  );

  getIt.registerLazySingleton<MoviesApi>(() => MoviesApiImpl(dotenv.env['TMDB_KEY']!));

  getIt.registerLazySingleton<DAO>(() => DAOImpl(getIt.get<Future<Database>>()));

  getIt.registerLazySingleton<MoviesRepository>(() {
    return MoviesRepositoryImpl(getIt.get<DAO>(), getIt.get<MoviesApi>());
  });
}
