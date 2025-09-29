import 'package:sqflite/sqflite.dart';

class ProdutoTable {
  static Future createProdutoTable(Database db) async {
    await db.execute('''
      CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        quantidade INTEGER NOT NULL
      )
    ''');
  }
}