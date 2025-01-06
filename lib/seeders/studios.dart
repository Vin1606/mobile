import 'package:sqflite/sqflite.dart';

Future<void> seedStudios(Batch batch) async {
  batch.insert('studios', {
    'name': 'Studio 1',
    'seat': 40,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('studios', {
    'name': 'Studio 2',
    'seat': 48,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('studios', {
    'name': 'Studio 3',
    'seat': 56,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
}
