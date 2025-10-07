import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_usecase.dart';

class ProdutoProvider with ChangeNotifier {
  List<Produto> produtos = [];
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository());

  Future<void> carregarProdutos() async {
    produtos = await produtoUseCase.carregarProdutos();
    notifyListeners();
  }
}