import 'package:supermercado/models/database_helper.dart';
import '../models/produto.dart';

class ProdutoController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> cadastrarProduto({
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
  }) async {
    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome do produto não pode estar vazio');
      }

      if (descricao.trim().isEmpty) {
        throw Exception('Descrição não pode estar vazia');
      }

      if (preco <= 0) {
        throw Exception('Preço deve ser maior que zero');
      }

      if (quantidadeEstoque < 0) {
        throw Exception('Quantidade em estoque não pode ser negativa');
      }

      final produto = Produto(
        nome: nome,
        descricao: descricao,
        preco: preco,
        quantidadeEstoque: quantidadeEstoque,
      );

      await _dbHelper.inserirProduto(produto);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> atualizarProduto({
    required int id,
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
  }) async {
    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome do produto não pode estar vazio');
      }

      if (descricao.trim().isEmpty) {
        throw Exception('Descrição não pode estar vazia');
      }

      if (preco <= 0) {
        throw Exception('Preço deve ser maior que zero');
      }

      if (quantidadeEstoque < 0) {
        throw Exception('Quantidade em estoque não pode ser negativa');
      }

      final produto = Produto(
        id: id,
        nome: nome,
        descricao: descricao,
        preco: preco,
        quantidadeEstoque: quantidadeEstoque,
      );

      await _dbHelper.atualizarProduto(produto);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removerProduto(int id) async {
    try {
      await _dbHelper.removerProduto(id);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Produto>> listarProdutos() async {
    return await _dbHelper.listarProdutos();
  }

  Future<Produto?> buscarProduto(int id) async {
    return await _dbHelper.buscarProdutoPorId(id);
  }

  Future<void> atualizarEstoque(int produtoId, int quantidadeVendida) async {
    try {
      final produto = await _dbHelper.buscarProdutoPorId(produtoId);
      
      if (produto == null) {
        throw Exception('Produto não encontrado');
      }

      final novoEstoque = produto.quantidadeEstoque - quantidadeVendida;
      
      if (novoEstoque < 0) {
        throw Exception('Estoque insuficiente');
      }

      await _dbHelper.atualizarEstoque(produtoId, novoEstoque);
    } catch (e) {
      rethrow;
    }
  }

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}