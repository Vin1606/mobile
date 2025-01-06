import '../models/schedule.dart';
import '../models/detail_schedule.dart';
import 'db.dart';

class ScheduleService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createSchedule(Schedule schedule) async {
    final db = await _dbService.database;
    return await db.insert('schedules', schedule.toMap());
  }

  Future<List<Schedule>> getSchedules() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return maps.map((map) => Schedule.fromMap(map)).toList();
  }

  Future<Schedule?> getScheduleById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('schedules', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Schedule.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSchedule(Schedule schedule) async {
    final db = await _dbService.database;
    return await db.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> deleteSchedule(int id) async {
    final db = await _dbService.database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DetailSchedule>> getDetailSchedule(int filmId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        schedules.*,
        films.title AS film_title,
        studios.name AS studio_name,
        studios.seat AS studio_seat
      FROM 
        schedules
      INNER JOIN 
        films ON schedules.film_id = films.id
      INNER JOIN 
        studios ON schedules.studio_id = studios.id
      WHERE 
        schedules.film_id = ?
    ''', [filmId]);
    return maps.map((map) => DetailSchedule.fromMap(map)).toList();
  }
}
