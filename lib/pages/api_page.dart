import 'package:flutter/material.dart';
import '../services/movie_api_service.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final MovieService movieService = MovieService();

  Future<void> _addMovieToDatabase(Map<String, dynamic> movie) async {
    try {
      await movieService.addMovieToLocal(movie);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film berhasil ditambahkan ke daftar')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film Populer')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: movieService.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return ListTile(
                title: Text(movie['title'] ?? ''),
                subtitle: Text(movie['overview'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addMovieToDatabase(movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
