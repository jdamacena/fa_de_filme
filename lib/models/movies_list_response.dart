import 'package:fa_de_filme/models/movie.dart';

class MoviesListResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MoviesListResponse({
    required this.results,
    required this.totalPages,
    required this.totalResults,
    required this.page,
  });

  factory MoviesListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsList = json['results'];

    return MoviesListResponse(
      page: json['page'],
      results: resultsList.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}
