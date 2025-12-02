import '../models/produto.dart';
import 'database_helper.dart';

class ProdutoDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Inserir novo produto
  Future<int> inserir(Produto produto) async {
    final db = await _dbHelper.database;
    return await db.insert('produtos', produto.toMap());
  }

  // Buscar produto por ID
  Future<Produto?> buscarPorId(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Produto.fromMap(maps.first);
  }

  // Listar todos os produtos
  Future<List<Produto>> listarTodos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  // Listar produtos com estoque disponível
  Future<List<Produto>> listarComEstoque() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'quantidadeEstoque > ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }

  // Atualizar produto
  Future<int> atualizar(Produto produto) async {
    final db = await _dbHelper.database;
    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  // Deletar produto
  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Atualizar apenas o estoque
  Future<int> atualizarEstoque(int produtoId, int novaQuantidade) async {
    final db = await _dbHelper.database;
    return await db.update(
      'produtos',
      {'quantidadeEstoque': novaQuantidade},
      where: 'id = ?',
      whereArgs: [produtoId],
    );
  }

  // Buscar produtos por nome (pesquisa)
  Future<List<Produto>> buscarPorNome(String nome) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
    );
    return List.generate(maps.length, (i) => Produto.fromMap(maps[i]));
  }
}