import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supermercado/models/produto.dart';
import 'package:supermercado/models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'supermercado.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        isAdministrador INTEGER NOT NULL
      )
    ''');

    // Tabela de Produtos
    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        preco REAL NOT NULL,
        quantidadeEstoque INTEGER NOT NULL
      )
    ''');
  }

  // CRUD de Usuários
  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> buscarUsuarioPorCpf(String cpf) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');
    return List.generate(maps.length, (i) => Usuario.fromMap(maps[i]));
  }

  // CRUD de Produtos
  Future<int> inserirProduto(Produto produto) async {
    final db = await database;
    return await db.insert('produtos', produto.toMap());
  }

  Future<int> atualizarProduto(Produto produto) async {
    final db = await database;
    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> removerProduto(int id) async {
    final db = await database;
    return await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Produto>> listarProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  Future<Produto?> buscarProdutoPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Produto.fromMap(maps.first);
  }

  Future<void> atualizarEstoque(int produtoId, int novaQuantidade) async {
    final db = await database;
    await db.update(
      'produtos',
      {'quantidadeEstoque': novaQuantidade},
      where: 'id = ?',
      whereArgs: [produtoId],
    );
  }

  Future<void> fecharDatabase() async {
    final db = await database;
    await db.close();
  }
}