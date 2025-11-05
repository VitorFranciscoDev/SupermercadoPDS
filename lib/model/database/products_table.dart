import 'package:sqflite/sqflite.dart';

class ProductsTable {
  static createTable(Database db) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        price REAL NOT NULL,
        quantity INT NOT NULL
      )
    ''');
  }
}