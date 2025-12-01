import 'produto.dart';

class ItemCarrinho {
  Produto _produto;
  int _quantidade;

  ItemCarrinho({
    required Produto produto,
    required int quantidade,
  })  : _produto = produto,
        _quantidade = quantidade;

  // Getters
  Produto get produto => _produto;
  int get quantidade => _quantidade;
  double get subtotal => _produto.preco * _quantidade;

  // Setters
  set produto(Produto value) => _produto = value;
  set quantidade(int value) => _quantidade = value;
}

class Carrinho {
  final List<ItemCarrinho> _itens = [];

  // Getters
  List<ItemCarrinho> get itens => List.unmodifiable(_itens);
  int get totalItens => _itens.fold(0, (sum, item) => sum + item.quantidade);
  double get totalGeral => _itens.fold(0.0, (sum, item) => sum + item.subtotal);

  // Adicionar produto ao carrinho
  void adicionarProduto(Produto produto, int quantidade) {
    if (quantidade > produto.quantidadeEstoque) {
      throw Exception('Quantidade solicitada maior que estoque disponível');
    }

    // Verifica se o produto já está no carrinho
    final index = _itens.indexWhere((item) => item.produto.id == produto.id);
    
    if (index != -1) {
      final novaQuantidade = _itens[index].quantidade + quantidade;
      if (novaQuantidade > produto.quantidadeEstoque) {
        throw Exception('Quantidade total excede o estoque disponível');
      }
      _itens[index].quantidade = novaQuantidade;
    } else {
      _itens.add(ItemCarrinho(produto: produto, quantidade: quantidade));
    }
  }

  // Remover produto do carrinho
  void removerProduto(int produtoId) {
    _itens.removeWhere((item) => item.produto.id == produtoId);
  }

  // Atualizar quantidade de um produto
  void atualizarQuantidade(int produtoId, int novaQuantidade) {
    final index = _itens.indexWhere((item) => item.produto.id == produtoId);
    
    if (index != -1) {
      if (novaQuantidade <= 0) {
        removerProduto(produtoId);
      } else if (novaQuantidade > _itens[index].produto.quantidadeEstoque) {
        throw Exception('Quantidade excede o estoque disponível');
      } else {
        _itens[index].quantidade = novaQuantidade;
      }
    }
  }

  // Limpar carrinho
  void limpar() {
    _itens.clear();
  }

  // Verificar se o carrinho está vazio
  bool get estaVazio => _itens.isEmpty;
}