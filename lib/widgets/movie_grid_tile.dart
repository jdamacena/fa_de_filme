import 'package:cached_network_image/cached_network_image.dart';
import 'package:fa_de_filme/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieGridTile extends StatelessWidget {
  final Movie movie;

  final void Function()? onTap;

  const MovieGridTile({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 16);
    const subtitleStyle = TextStyle(fontSize: 12);

    var inputDate = DateTime.parse(movie.releaseDate);
    var outputFormat = DateFormat('dd/MM/yyyy');

    String formattedReleaseDate = outputFormat.format(inputDate);

    return GridTile(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.image),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      movie.title,
                      style: titleStyle,
                    ),
                    Text(
                      formattedReleaseDate,
                      style: subtitleStyle,
                    ),
                    Row(
                      children: [
                        Text(
                          "${movie.voteAverage.toStringAsFixed(1)}/10",
                          style: subtitleStyle,
                        ),
                        const Icon(
                          Icons.star,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
