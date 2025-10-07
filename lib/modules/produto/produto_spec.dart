import 'package:supermercado/entities/produto.dart';

abstract class IProdutoUseCase {
  String? validarNome(String nome);

  String? validarPreco(String preco);

  String? validarQuantidade(String quantidade);

  Future<Produto?> cadastrarProduto(String nome, double preco, int quantidade);

  //Future<Produto?> editarProduto(Produto produto);

  Future<void> excluirProduto(Produto produto);
}