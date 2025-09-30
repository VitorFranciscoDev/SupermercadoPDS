import 'package:sqflite/sqflite.dart';

class UsuarioTable {
  static Future createUsuarioTable(Database db) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        tipoUsuario INTEGER NOT NULL
      )
    ''');
  }
}