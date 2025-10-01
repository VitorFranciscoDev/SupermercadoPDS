import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';

class ProdutoRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  Future<int> registrarProduto(Produto produto) async {
    final db = await dbProvider.database;
    Map<String, dynamic> produtoMap = produto.toMap();
    return await db.insert('produtos', produtoMap);
  }

  Future<Produto?> buscarProdutoPorId(Produto produto) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [produto.id],
    );

    result.isNotEmpty ? produto : null;
    return null;
  }
}