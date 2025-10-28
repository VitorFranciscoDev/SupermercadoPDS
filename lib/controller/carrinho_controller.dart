import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/controller/produto_controller.dart';

class CarrinhoController with ChangeNotifier {
  final ProdutoController produtoController;
  List<Produto> carrinho = [];

  CarrinhoController({required this.produtoController});

  // função para adicionar item no carrinho
  void adicionarItem(BuildContext context, Produto novoProduto, int quantidade) {
    final index = carrinho.indexWhere((p) => p.id == novoProduto.id);
    if (index >= 0) {
      carrinho[index] = Produto(
        id: carrinho[index].id,
        nome: carrinho[index].nome,
        preco: carrinho[index].preco,
        quantidade: carrinho[index].quantidade + quantidade,
      );
    } else {
      carrinho.add(
        Produto(
          id: novoProduto.id,
          nome: novoProduto.nome,
          preco: novoProduto.preco,
          quantidade: quantidade,
        ),
      );
    }

    // Pega o provider correto
    context.read<ProdutoController>().diminuirEstoque(novoProduto, quantidade);

    notifyListeners();
  }

  // limpa o carrinho
  void limparCarrinho() {
    carrinho.clear();
    notifyListeners();
  }
}
