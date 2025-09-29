import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';

class ProdutoProvider with ChangeNotifier {
  List<Produto> produtos = [];

  void addProduto(Produto produto) {
    produtos.add(produto);
    notifyListeners();
  }

  void excluirProduto(Produto produto) {
    produtos.remove(produto);
    notifyListeners();
  }
}