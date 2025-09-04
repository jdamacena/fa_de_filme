import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:test/test.dart';

void main() {
  group('MoviesListResponse', () {
    test('should create MoviesListResponse from JSON', () {
      final json = {
        'page': 1,
        'results': [
          {
            'id': 1,
            'title': 'Movie 1',
            'release_date': '2023-01-01',
            'vote_average': 8.5,
            'poster_path': '/poster1.jpg',
          },
          {
            'id': 2,
            'title': 'Movie 2',
            'release_date': '2023-01-02',
            'vote_average': 7.5,
            'poster_path': '/poster2.jpg',
          }
        ],
        'total_pages': 10,
        'total_results': 100
      };

      final response = MoviesListResponse.fromJson(json);

      expect(response.page, 1);
      expect(response.totalPages, 10);
      expect(response.totalResults, 100);
      expect(response.results.length, 2);

      // Verify first movie
      expect(response.results[0].id, 1);
      expect(response.results[0].title, 'Movie 1');
      expect(response.results[0].releaseDate, '2023-01-01');
      expect(response.results[0].voteAverage, 8.5);
      expect(response.results[0].posterPath, '/poster1.jpg');

      // Verify second movie
      expect(response.results[1].id, 2);
      expect(response.results[1].title, 'Movie 2');
      expect(response.results[1].releaseDate, '2023-01-02');
      expect(response.results[1].voteAverage, 7.5);
      expect(response.results[1].posterPath, '/poster2.jpg');
    });

    test('should handle empty results list', () {
      final json = {
        'page': 1,
        'results': [],
        'total_pages': 0,
        'total_results': 0
      };

      final response = MoviesListResponse.fromJson(json);

      expect(response.page, 1);
      expect(response.results, isEmpty);
      expect(response.totalPages, 0);
      expect(response.totalResults, 0);
    });
  });
}
