import 'package:fa_de_filme/models/movie.dart';
import 'package:test/test.dart';

void main() {
  group('Movie Model', () {
    test('should create Movie instance with required parameters', () {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        releaseDate: '2023-01-01',
        voteAverage: 8.5,
        posterPath: '/path/to/poster.jpg',
      );

      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.releaseDate, '2023-01-01');
      expect(movie.voteAverage, 8.5);
      expect(movie.posterPath, '/path/to/poster.jpg');
      expect(movie.runtime, 0); // default value
      expect(movie.overview, ""); // default value
      expect(movie.isFavorite, false); // default value
    });

    test('should create Movie from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Test Overview',
        'release_date': '2023-01-01',
        'poster_path': '/path/to/poster.jpg',
        'vote_average': 8.5,
        'runtime': 120,
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.overview, 'Test Overview');
      expect(movie.releaseDate, '2023-01-01');
      expect(movie.posterPath, '/path/to/poster.jpg');
      expect(movie.voteAverage, 8.5);
      expect(movie.runtime, 120);
    });

    test('should handle missing or null JSON values', () {
      final json = {
        'id': 1,
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 1);
      expect(movie.title, "");
      expect(movie.overview, "-");
      expect(movie.releaseDate, "-");
      expect(movie.posterPath, "");
      expect(movie.voteAverage, -1.0);
      expect(movie.runtime, -1);
    });

    test('should convert Movie to Map', () {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        releaseDate: '2023-01-01',
        voteAverage: 8.5,
        posterPath: '/path/to/poster.jpg',
        runtime: 120,
        overview: 'Test Overview',
        isFavorite: true,
      );

      final map = movie.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test Movie');
      expect(map['overview'], 'Test Overview');
      expect(map['release_date'], '2023-01-01');
      expect(map['poster_path'], '/path/to/poster.jpg');
      expect(map['vote_average'], 8.5);
      expect(map['runtime'], 120);
      expect(map['is_favorite'], 1); // Should be 1 for true
    });
  });
}
