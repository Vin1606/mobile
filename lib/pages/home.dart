import 'package:bioskopks/pages/api_page.dart';
import 'package:flutter/material.dart';
import '../models/film.dart';
import '../services/film.dart';
import '../widgets/film_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Film> _films = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilms();
  }

  Future<void> _loadFilms() async {
    final films = await FilmService().getFilms();

    setState(() {
      _films = films;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 43, 74),
        title: const Row(
          children: [
            Icon(
              Icons.movie,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Daftar Film',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          : _films.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Film belum tersedia',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _films.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FilmCard(film: _films[index]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MovieScreen(), // Pastikan ini ke MovieScreen
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 0, 43, 74),
        child: const Icon(Icons.api),
      ),
    );
  }
}
