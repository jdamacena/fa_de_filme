import 'package:fa_de_filme/utils/constants.dart';
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


}
