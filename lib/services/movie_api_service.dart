import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';
import 'film.dart';

class MovieService {
  final String apiKey = '207d957610f64e73bd330c2a26998aa6';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  
  final FilmService _filmService = FilmService();

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=id-ID'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Convert TMDb movie to our Film model
  Film tmdbMovieToFilm(Map<String, dynamic> tmdbMovie) {
    return Film(
      id: null, // SQLite will auto-generate
      title: tmdbMovie['title'],
      description: tmdbMovie['overview'],
      director: 'TBD', // TMDb API doesn't provide director in basic response
      rating: tmdbMovie['vote_average'].toString(),
      language: tmdbMovie['original_language'],
      subtitle: 'Indonesia', // Default value
      trailer: '', // Need separate API call to get trailer
      poster: '$imageBaseUrl${tmdbMovie['poster_path']}',
      genre: '', // Need to map genre IDs to names
      duration: 0, // Need separate API call to get duration
    );
  }

  // Add movie from TMDb to local database
  Future<int> addMovieToLocal(Map<String, dynamic> tmdbMovie) async {
    final film = tmdbMovieToFilm(tmdbMovie);
    return await _filmService.createFilm(film);
  }

  // Get movie details including runtime and trailer
  Future<Map<String, dynamic>> getMovieDetails(int tmdbId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$tmdbId?api_key=$apiKey&append_to_response=videos&language=id-ID'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
