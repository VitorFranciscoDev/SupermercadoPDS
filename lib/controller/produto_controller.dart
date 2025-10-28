import 'package:flutter/material.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/model/produtoDAO.dart';

class ProdutoController with ChangeNotifier {
  List<Produto> produtos = [];
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository());

  // carrega produtos do banco
  Future<void> carregarProdutos() async {
    produtos = await produtoUseCase.carregarProdutos();
    notifyListeners();
  }

  // diminui a quantidade do produto corretamente e atualiza no banco
  Future<void> diminuirEstoque(Produto produto, int quantidadeComprada) async {
    final index = produtos.indexWhere((p) => p.id == produto.id);
    if (index == -1) return;

    final produtoAtual = produtos[index];
    final novaQuantidade = produtoAtual.quantidade - quantidadeComprada;

    if (novaQuantidade <= 0) {
      // remove do banco
      await produtoUseCase.excluirProduto(produtoAtual);
      // remove da lista
      produtos.removeAt(index);
    } else {
      // atualiza no banco
      Produto produtoAtualizado = Produto(
        id: produtoAtual.id,
        nome: produtoAtual.nome,
        preco: produtoAtual.preco,
        quantidade: novaQuantidade,
      );

      await produtoUseCase.editarProduto(
        produtoAtual,
        produtoAtualizado.nome,
        produtoAtualizado.preco,
        produtoAtualizado.quantidade,
      );

      produtos[index] = produtoAtualizado;
    }

    notifyListeners();
  }

}
