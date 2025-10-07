import 'package:sqflite/sqflite.dart';

class ProdutoTable {
  // cria a tabela de produtos
  static createProdutoTable(Database db) async {
    await db.execute('''
      CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        preco REAL NOT NULL,
        quantidade INTEGER NOT NULL
      )
    ''');
  }
}