import 'package:supermercado/entities/produto.dart';

// classe abstrata com os contratos
abstract class IProdutoUseCase {
  String? validarNome(String nome);

  String? validarPreco(String preco);

  String? validarQuantidade(String quantidade);

  Future<Produto?> cadastrarProduto(String nome, double preco, int quantidade);

  Future<bool> editarProduto(Produto produto, String nome, double preco, int quantidade);

  Future<bool> excluirProduto(Produto produto);
}