import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:supermercado/model/database/usuario_table.dart';
import 'produto_table.dart';

class DatabaseProvider with ChangeNotifier {
  static final DatabaseProvider instance = DatabaseProvider._internal();
  factory DatabaseProvider() => instance;
  DatabaseProvider._internal();
  static Database? db;

  // getter pro Database
  Future<Database> get database async {
    if(db!=null) return db!; // se for diferente de null, retorna o db

    // se não for, inicia o db e o retorna depois
    db = await initDB();
    return db!;
  }

  // inicializa o banco e as tabelas
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "supermercado.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await UsuarioTable.createUsuarioTable(db);
        await ProdutoTable.createProdutoTable(db);
      },
    );
  }
}