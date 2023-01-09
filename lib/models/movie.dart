class Movie {
  final int id;

  /// Título do filme
  String title;

  /// Sinopse, descrição
  String overview;

  /// Data de lançamento
  String releaseDate;

  /// Nota, avaliação do filme
  double voteAverage;

  /// Duração em minutos
  int runtime;

  /// Endereço da imagem da capa
  String posterPath;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.posterPath,
    this.runtime = 0,
    this.overview = "",
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? "",
      posterPath: json['poster_path'] ?? "",
      overview: json['overview'] ?? "-",
      voteAverage: ((json['vote_average'] ?? -1) as num).toDouble(),
      releaseDate:  json['release_date'] ?? "-",
      runtime: json['runtime'] ?? -1,
    );
  }

  // Convert into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'release_date': releaseDate,
      'poster_path': posterPath,
      'is_favorite': isFavorite ? 1 : 0,
      'vote_average': voteAverage,
      'runtime': runtime,
    };
  }

  @override
  String toString() {
    return 'Movie{'
        'id $id, '
        'title $title, '
        'overview $overview, '
        'release_date $releaseDate, '
        'poster_path $posterPath, '
        'is_favorite $isFavorite, '
        'vote_average $voteAverage, '
        'runtime $runtime'
        '}';
  }
}
