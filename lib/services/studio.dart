import '../models/studio.dart';
import 'db.dart';

class StudioService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createStudio(Studio studio) async {
    final db = await _dbService.database;
    return await db.insert('studios', studio.toMap());
  }

  Future<List<Studio>> getStudios() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('studios');
    return maps.map((map) => Studio.fromMap(map)).toList();
  }

  Future<Studio?> getStudioById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('studios', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Studio.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStudio(Studio studio) async {
    final db = await _dbService.database;
    return await db.update(
      'studios',
      studio.toMap(),
      where: 'id = ?',
      whereArgs: [studio.id],
    );
  }

  Future<int> deleteStudio(int id) async {
    final db = await _dbService.database;
    return await db.delete('studios', where: 'id = ?', whereArgs: [id]);
  }
}
