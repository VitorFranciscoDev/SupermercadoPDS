import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';

class ProdutoRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  // função para registrar o produto no banco
  Future<int> registrarProduto(Produto produto) async {
    final db = await dbProvider.database;
    return await db.insert('produtos', produto.toMap());
  }

  // função para excluir o produto
  Future<int> excluirProduto(int? id) async {
    final db = await dbProvider.database;

    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  // função para editar o produto
  Future<int> editarProduto(Produto produto) async {
    final db = await dbProvider.database;

    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  } 

  // função para listar os produtos
  Future<List<Produto>> listarProdutos() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }
}