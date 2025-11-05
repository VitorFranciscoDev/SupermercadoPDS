import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supermercado/database/products_table.dart';
import 'package:supermercado/database/users_table.dart';

// Creation of DB and Tables
class SupermercadoDatabase {
  static final SupermercadoDatabase _instance = SupermercadoDatabase._internal();
  factory SupermercadoDatabase() => _instance;
  SupermercadoDatabase._internal();
  static Database? db;

  // DB getter
  Future<Database> get database async {
    if(db != null) return db!;
    db = await _initDatabase();
    return db!;
  }

  // Init DB
  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'trip_planner.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        UsersTable.createTable(db);
        ProductsTable.createTable(db);
      },
    );
  }
}