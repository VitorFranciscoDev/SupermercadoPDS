import 'package:supermercado/infrastructure/database/database_provider.dart';

class ProdutoRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  Future<int> registrarProduto(Map<String, dynamic> produto) async {
    final db = await dbProvider.database;
    return await db.insert('produtos', produto);
  }
}