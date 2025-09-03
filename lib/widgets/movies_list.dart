import 'package:fa_de_filme/di/service_locator.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/pages/details_page.dart';
import 'package:fa_de_filme/repository/movies_repository.dart';
import 'package:fa_de_filme/widgets/movie_grid_tile.dart';
import 'package:flutter/material.dart';

class MoviesListWidget extends StatefulWidget {
  const MoviesListWidget({super.key});

  @override
  MoviesListWidgetState createState() => MoviesListWidgetState();
}

class MoviesListWidgetState extends State<MoviesListWidget> {
  static const _pageSize = 20;
  final ValueNotifier<List<Movie>> _movies = ValueNotifier<List<Movie>>([]);
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasNextPage) return;

    setState(() => _isLoading = true);

    try {
      final moviesRepository = getIt.get<MoviesRepository>();
      final moviesResponse = await moviesRepository.getNowPlaying(_currentPage);
      final newMovies = moviesResponse.results;

      _movies.value = [..._movies.value, ...newMovies];
      _hasNextPage = newMovies.length >= _pageSize;
      _currentPage++;
    } catch (error) {
      debugPrint('Error loading movies: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    _hasNextPage = true;
    _movies.value = [];
    await _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var axisCount = 2;

    if (screenWidth >= 992.0) {
      axisCount = 5;
    } else if (screenWidth >= 768.0) {
      axisCount = 4;
    } else if (screenWidth >= 576.0) {
      axisCount = 3;
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ValueListenableBuilder<List<Movie>>(
        valueListenable: _movies,
        builder: (context, movies, child) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoading &&
                  _hasNextPage &&
                  scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.9) {
                _loadNextPage();
              }
              return true;
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: axisCount,
                childAspectRatio: 0.75,
              ),
              itemCount: movies.length + (_hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= movies.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final movie = movies[index];
                return MovieGridTile(
                  movie: movie,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(movie: movie),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _movies.dispose();
    super.dispose();
  }
}
