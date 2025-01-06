import '../models/film.dart';
import 'db.dart';

class FilmService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createFilm(Film film) async {
    final db = await _dbService.database;
    return await db.insert('films', film.toMap());
  }

  Future<List<Film>> getFilms() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('films');
    return maps.map((map) => Film.fromMap(map)).toList();
  }

  Future<Film?> getFilmById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('films', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Film.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateFilm(Film film) async {
    final db = await _dbService.database;
    return await db.update(
      'films',
      film.toMap(),
      where: 'id = ?',
      whereArgs: [film.id],
    );
  }

  Future<int> deleteFilm(int id) async {
    final db = await _dbService.database;
    return await db.delete('films', where: 'id = ?', whereArgs: [id]);
  }
}
