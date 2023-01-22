import 'dart:convert';

import 'package:fa_de_filme/models/movie.dart';
import 'package:test/test.dart';

void main() {
  group('Movie.toMap', () {
    late Movie movie;

    setUp(() {
      movie = Movie(
          id: 99,
          title: "title",
          releaseDate: '2022-01-01',
          voteAverage: 1.23,
          posterPath: '/posterPath',
          isFavorite: false);
    });

    test('should contain the correct keys', () {
      const expectedMovieMap = {
        'id': 99,
        'title': "title",
        'overview': "",
        'release_date': "2022-01-01",
        'poster_path': "/posterPath",
        'is_favorite': 0,
        'vote_average': 1.23,
        'runtime': 0,
      };

      var movieMap = movie.toMap();

      expect(movieMap.keys, expectedMovieMap.keys);
    });

    test('should generate the correct values', () {
      const expectedMovieMap = {
        'id': 99,
        'title': "title",
        'overview': "",
        'release_date': "2022-01-01",
        'poster_path': "/posterPath",
        'is_favorite': 0,
        'vote_average': 1.23,
        'runtime': 0,
      };

      var movieMap = movie.toMap();

      expect(movieMap["id"], expectedMovieMap["id"]);
      expect(movieMap["title"], expectedMovieMap["title"]);
      expect(movieMap["runtime"], expectedMovieMap["runtime"]);
      expect(movieMap["overview"], expectedMovieMap["overview"]);
      expect(movieMap["poster_path"], expectedMovieMap["poster_path"]);
      expect(movieMap["is_favorite"], expectedMovieMap["is_favorite"]);
      expect(movieMap["vote_average"], expectedMovieMap["vote_average"]);
      expect(movieMap["release_date"], expectedMovieMap["release_date"]);
    });

    test('boolean properties should come as 1 or 0', () {
      movie.isFavorite = false;
      expect(movie.toMap()['is_favorite'], 0);

      movie.isFavorite = true;
      expect(movie.toMap()['is_favorite'], 1);
    });
  });

  group('Movie.fromJson', () {
    test("should convert JSON to Movie", () {
      var jsonString = '''
      {
          "id": 315,
          "overview": "lorem ipsum",
          "poster_path": "/poster.jpg",
          "release_date": "2022-12-07",
          "runtime": 102,
          "title": "titulo filme",
          "vote_average": 8.4
      }
      ''';

      var json = jsonDecode(jsonString);

      var movie = Movie.fromJson(json);

      var expectedMovie = Movie(
        id: 315,
        title: "titulo filme",
        releaseDate: "2022-12-07",
        voteAverage: 8.4,
        posterPath: "/poster.jpg",
        overview: "lorem ipsum",
        runtime: 102,
      );

      expect(expectedMovie.toString(), movie.toString());
    });
  });
}
