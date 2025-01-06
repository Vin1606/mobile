import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/session.dart';
import 'db.dart';

class UserService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createUser(User user) async {
    final db = await _dbService.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbService.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> login(String email, String password) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      User? user = User.fromMap(maps.first);
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt('userId', user.id!);
      await sharedPreferences.setBool(
          'isAdmin', user.isAdmin == 1 ? true : false);
      await sharedPreferences.setBool('isLoggedIn', true);

      return true;
    }

    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final isRegistered = await createUser(User(
      name: name,
      email: email,
      password: password,
      isAdmin: 0,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    ));

    if (isRegistered > 0) {
      await login(email, password);

      return true;
    }

    return false;
  }

  void logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  Future<Session> getSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return Session(
      userId: sharedPreferences.getInt('userId') ?? 0,
      isAdmin: sharedPreferences.getBool('isAdmin') ?? false,
      isLoggedIn: sharedPreferences.getBool('isLoggedIn') ?? false,
    );
  }
}
