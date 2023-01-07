import 'package:fa_de_filme/models/movie.dart';
import 'package:flutter/material.dart';

/// Página de detalhes dos filmes
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget getImageWidget(Movie movie) {
    var imagePath = movie.posterPath.isNotEmpty
        ? movie.posterPath
        : 'https://picsum.photos/250?image=9';

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Container(
          color: Colors.deepPurple,
          child: Image.network(
            imagePath,
            height: 208.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            tooltip: "Favoritar",
            icon: const Icon(
              Icons.bookmark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: getImageWidget(widget.movie),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Data de lançamento: ${widget.movie.releaseDate}"),
                        Text("Duração: ${widget.movie.runtime}min."),
                        Text(
                            "Nota: ${widget.movie.voteAverage.toStringAsFixed(2)}/10⭐"),
                      ],
                    ),
                  ),
                  const Divider(),
                  Text(
                    widget.movie.overview,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
