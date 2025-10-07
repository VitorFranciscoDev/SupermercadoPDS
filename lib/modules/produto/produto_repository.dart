import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';

class ProdutoRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  Future<int> registrarProduto(Produto produto) async {
    final db = await dbProvider.database;
    Map<String, dynamic> produtoMap = produto.toMap();
    return await db.insert('produtos', produtoMap);
  }

  Future<void> excluirProduto(int? id) async {
    final db = await dbProvider.database;

    await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Produto>> listarProdutos() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }
}