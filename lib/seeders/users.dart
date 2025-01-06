import 'package:sqflite/sqflite.dart';

Future<void> seedUsers(Batch batch) async {
  batch.insert('users', {
    'name': 'Admin',
    'email': 'admin@bks.com',
    'password': '123',
    'is_admin': 1,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('users', {
    'name': 'Kevin',
    'email': 'kevin@gmail.com',
    'password': '123',
    'is_admin': 0,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('users', {
    'name': 'Fajar',
    'email': 'fajar@gmail.com',
    'password': '123',
    'is_admin': 0,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('users', {
    'name': 'Melani',
    'email': 'melani@gmail.com',
    'password': '123',
    'is_admin': 0,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('users', {
    'name': 'Serlina',
    'email': 'serlina@gmail.com',
    'password': '123',
    'is_admin': 0,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
  batch.insert('users', {
    'name': 'Nabila',
    'email': 'nabila@gmail.com',
    'password': '123',
    'is_admin': 0,
    'created_at': DateTime.now().toString(),
    'updated_at': DateTime.now().toString(),
  });
}
