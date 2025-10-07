import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_usecase.dart';

class ProdutoProvider with ChangeNotifier {
  List<Produto> produtos = []; // lista de produtos
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository()); // casos de uso do produto

  // função para carregar os produtos
  Future<void> carregarProdutos() async {
    produtos = await produtoUseCase.carregarProdutos();
    notifyListeners();
  }
}