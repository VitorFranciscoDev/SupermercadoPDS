import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';

class CarrinhoProvider with ChangeNotifier {
  final ProdutoProvider produtoProvider;
  List<Produto> carrinho = [];

  CarrinhoProvider({required this.produtoProvider});

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
    context.read<ProdutoProvider>().diminuirEstoque(novoProduto, quantidade);

    notifyListeners();
  }

  // limpa o carrinho
  void limparCarrinho() {
    carrinho.clear();
    notifyListeners();
  }
}
