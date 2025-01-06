class Film {
  int? id;
  String title;
  String description;
  String director;
  String rating;
  String language;
  String subtitle;
  String trailer;
  String poster;
  String genre;
  int duration;

  Film({
    this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.rating,
    required this.language,
    required this.subtitle,
    required this.trailer,
    required this.poster,
    required this.genre,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'director': director,
      'rating': rating,
      'language': language,
      'subtitle': subtitle,
      'trailer': trailer,
      'poster': poster,
      'genre': genre,
      'duration': duration,
    };
  }

  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      director: map['director'],
      rating: map['rating'],
      language: map['language'],
      subtitle: map['subtitle'],
      trailer: map['trailer'],
      poster: map['poster'],
      genre: map['genre'],
      duration: map['duration'],
    );
  }
}
