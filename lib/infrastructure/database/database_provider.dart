import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:supermercado/infrastructure/database/usuario_table.dart';
import 'produto_table.dart';

class DatabaseProvider with ChangeNotifier {
  static final DatabaseProvider instance = DatabaseProvider._internal();
  factory DatabaseProvider() => instance;
  DatabaseProvider._internal();
  static Database? db;

  Future<Database> get database async {
    if(db!=null) return db!;
    db = await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "supermercado.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        UsuarioTable.createUsuarioTable(db);
        ProdutoTable.createProdutoTable(db);
      },
    );
  }
}