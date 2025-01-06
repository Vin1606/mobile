import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../seeders/users.dart';
import '../seeders/films.dart';
import '../seeders/studios.dart';
// import '../seeders/schedules.dart';
// import '../seeders/orders.dart';
// import '../seeders/order_seats.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bioskopks.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      // Running Migrations
      txn.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          password TEXT,
          is_admin INTEGER,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
      txn.execute('''
        CREATE TABLE films (
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          director TEXT,
          rating TEXT,
          language TEXT,
          subtitle TEXT,
          trailer TEXT,
          poster TEXT,
          genre TEXT,
          duration INTEGER,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
      txn.execute('''
        CREATE TABLE studios (
          id INTEGER PRIMARY KEY,
          name TEXT,
          seat INTEGER,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
      txn.execute('''
        CREATE TABLE schedules (
          id INTEGER PRIMARY KEY,
          film_id INTEGER,
          studio_id INTEGER,
          time TEXT,
          price INTEGER,
          available INTEGER,
          created_at TEXT,
          updated_at TEXT,
          FOREIGN KEY (film_id) REFERENCES films (id),
          FOREIGN KEY (studio_id) REFERENCES studios (id)
        )
      ''');
      txn.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          film_id INTEGER,
          schedule_id INTEGER,
          ticket INTEGER,
          total_price INTEGER,
          method TEXT,
          note TEXT,
          payment_proof TEXT,
          status TEXT,
          confirmed_by INTEGER,
          created_at TEXT,
          updated_at TEXT,
          confirmed_at TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id),
          FOREIGN KEY (film_id) REFERENCES films (id),
          FOREIGN KEY (schedule_id) REFERENCES schedules (id)
        )
      ''');
      txn.execute('''
        CREATE TABLE order_seats (
          id INTEGER PRIMARY KEY,
          order_id INTEGER,
          seat TEXT,
          created_at TEXT,
          updated_at TEXT,
          FOREIGN KEY (order_id) REFERENCES orders (id)
        )
      ''');

      // Running Seeders
      Batch batch = txn.batch();
      await seedUsers(batch);
      await seedFilms(batch);
      await seedStudios(batch);
      // await seedSchedules(batch);
      // await seedOrders(batch);
      // await seedOrderSeats(batch);
      await batch.commit(noResult: true);
    });
  }
}
