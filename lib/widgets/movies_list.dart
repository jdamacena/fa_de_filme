import 'package:fa_de_filme/di/service_locator.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/models/movies_list_response.dart';
import 'package:fa_de_filme/pages/details_page.dart';
import 'package:fa_de_filme/repository/movies_api.dart';
import 'package:fa_de_filme/widgets/movie_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MoviesListWidget extends StatefulWidget {
  const MoviesListWidget({super.key});

  @override
  MoviesListWidgetState createState() => MoviesListWidgetState();
}

class MoviesListWidgetState extends State<MoviesListWidget> {
  static const _pageSize = 20;

  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoviesPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchMoviesPage(int pageKey) async {
    MoviesApi moviesApi = getIt.get<MoviesApi>();

    try {
      MoviesListResponse moviesListResponse = await moviesApi.getNowPlaying(pageKey);
      List<Movie> newItems = moviesListResponse.results;

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
    } else {
      axisCount = 2;
    }

    var gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: axisCount,
      childAspectRatio: 0.75,
    );

    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedGridView<int, Movie>(
        padding: const EdgeInsets.all(0.0),
        gridDelegate: gridDelegate,
        pagingController: _pagingController,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        builderDelegate: PagedChildBuilderDelegate<Movie>(
          itemBuilder: (context, movie, index) {

            return MovieGridTile(
              movie: movie,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailsPage(movie: movie);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
