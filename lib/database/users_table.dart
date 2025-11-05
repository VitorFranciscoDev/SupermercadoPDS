import 'package:sqflite/sqflite.dart';

class UsersTable {
  static createTable(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cpf TEXT UNIQUE NOT NULL,
        isAdmin INT NOT NULL
      )
    ''');
  }
}