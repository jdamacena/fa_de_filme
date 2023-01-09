import 'package:fa_de_filme/pages/home_page.dart';
import 'package:fa_de_filme/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
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
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fã de Filme',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(title: 'Fã de Filme'),
    );
  }
}