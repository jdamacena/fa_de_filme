import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:fa_de_filme/repository/datasources/dao.dart';
import 'package:fa_de_filme/repository/datasources/movies_api.dart';
import 'package:fa_de_filme/repository/movies_repository_impl.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<DAO>(), MockSpec<MoviesApi>()])
import 'movies_repository_test.mocks.dart';

void main() {
  late MockDAO mockDao;
  late MockMoviesApi mockMoviesApi;
  late MoviesRepositoryImpl repository;

  setUp(() {
    mockDao = MockDAO();
    mockMoviesApi = MockMoviesApi();
    repository = MoviesRepositoryImpl(mockDao, mockMoviesApi);
  });

  group('MoviesRepository', () {
    test('getNowPlaying should return MoviesListResponse from API', () async {
      final expectedResponse = MoviesListResponse(
        page: 1,
        results: [
          Movie(
            id: 1,
            title: 'Test Movie',
            releaseDate: '2023-01-01',
            voteAverage: 8.5,
            posterPath: '/test.jpg',
          )
        ],
        totalPages: 1,
        totalResults: 1,
      );

      when(mockMoviesApi.getNowPlaying(1))
          .thenAnswer((_) async => expectedResponse);

      final result = await repository.getNowPlaying(1);

      verify(mockMoviesApi.getNowPlaying(1)).called(1);
      expect(result.page, expectedResponse.page);
      expect(result.results.length, expectedResponse.results.length);
      expect(result.totalPages, expectedResponse.totalPages);
    });

    test('getMovieDetails should return Movie from API', () async {
      final expectedMovie = Movie(
        id: 1,
        title: 'Test Movie',
        releaseDate: '2023-01-01',
        voteAverage: 8.5,
        posterPath: '/test.jpg',
      );

      when(mockMoviesApi.getMovieDetails(1))
          .thenAnswer((_) async => expectedMovie);

      final result = await repository.getMovieDetails(1);

      verify(mockMoviesApi.getMovieDetails(1)).called(1);
      expect(result.id, expectedMovie.id);
      expect(result.title, expectedMovie.title);
    });

    test('listFavoriteMovies should return movies from DAO', () async {
      final expectedMovies = [
        Movie(
          id: 1,
          title: 'Favorite Movie',
          releaseDate: '2023-01-01',
          voteAverage: 8.5,
          posterPath: '/test.jpg',
        )
      ];

      when(mockDao.listFavoriteMovies())
          .thenAnswer((_) async => expectedMovies);

      final result = await repository.listFavoriteMovies();

      verify(mockDao.listFavoriteMovies()).called(1);
      expect(result.length, expectedMovies.length);
      expect(result.first.id, expectedMovies.first.id);
    });

    test('saveAsFavorite should call DAO', () async {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        releaseDate: '2023-01-01',
        voteAverage: 8.5,
        posterPath: '/test.jpg',
      );

      when(mockDao.saveAsFavorite(movie))
          .thenAnswer((_) async => {});

      await repository.saveAsFavorite(movie);

      verify(mockDao.saveAsFavorite(movie)).called(1);
    });

    test('deleteFavorite should call DAO', () async {
      when(mockDao.deleteFavorite(1))
          .thenAnswer((_) async => {});

      await repository.deleteFavorite(1);

      verify(mockDao.deleteFavorite(1)).called(1);
    });

    test('isFavorite should return boolean from DAO', () async {
      when(mockDao.isFavorite(1))
          .thenAnswer((_) async => true);

      final result = await repository.isFavorite(1);

      verify(mockDao.isFavorite(1)).called(1);
      expect(result, true);
    });
  });
}
