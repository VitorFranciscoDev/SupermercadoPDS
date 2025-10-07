import 'package:flutter/widgets.dart';
import 'package:supermercado/entities/produto.dart';

class CarrinhoProvider with ChangeNotifier {
  List<Produto> carrinho = [];
  double soma = 0;

  void adicionarItem(Produto novoProduto, int quantidade) {
    final index = carrinho.indexWhere((p) => p.nome == novoProduto.nome);
    if (index >= 0) {
      Produto atualizado = Produto(
        nome: carrinho[index].nome,
        preco: carrinho[index].preco,
        quantidade: carrinho[index].quantidade + quantidade,
      );
      carrinho[index] = atualizado;
    } else {
      carrinho.add(
        Produto(nome: novoProduto.nome, preco: novoProduto.preco, quantidade: quantidade),
      );
    }
    notifyListeners();
  }

  void limparCarrinho() {
    carrinho.clear();
    notifyListeners();
  }

  double get somaTotal {
    return carrinho.fold(0, (total, car) => total + car.preco * car.quantidade);
  }

}