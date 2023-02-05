import 'package:fa_de_filme/di/service_locator.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:fa_de_filme/pages/details_page.dart';
import 'package:fa_de_filme/repository/movies_repository.dart';
import 'package:fa_de_filme/widgets/movie_grid_tile.dart';
import 'package:flutter/material.dart';

/// Página de filmes favoritos
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Movie>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = getIt.get<MoviesRepository>().listFavoriteMovies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 05/02/2023 add pull to refresh functionality
    var content = FutureBuilder<List<Movie>>(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return generateMoviesGrid(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
      ),
      body: content,
    );
  }

  Widget generateMoviesGrid(BuildContext context, List<Movie> list) {
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

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.movie, size: 36.0,),
            Text("Você ainda não salvou nenhum filme"),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshPage,
      child: Container(
        color: Colors.deepPurple.withAlpha(220),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: axisCount,
            childAspectRatio: 0.75,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: list.length,
          itemBuilder: ((context, index) {
            var movie = list[index];

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
          }),
        ),
      ),
    );
  }

  Future<void> refreshPage() async {
    setState(() {
      futureAlbum = getIt.get<MoviesRepository>().listFavoriteMovies();
    });
  }
}
