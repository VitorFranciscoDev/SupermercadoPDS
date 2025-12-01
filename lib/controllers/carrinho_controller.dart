import '../models/carrinho.dart';
import '../models/produto.dart';
import '../models/usuario.dart';
import 'produto_controller.dart';

class CarrinhoController {
  final Carrinho _carrinho = Carrinho();
  final ProdutoController _produtoController = ProdutoController();

  Carrinho get carrinho => _carrinho;

  void adicionarAoCarrinho(Produto produto, int quantidade) {
    try {
      _carrinho.adicionarProduto(produto, quantidade);
    } catch (e) {
      rethrow;
    }
  }

  void removerDoCarrinho(int produtoId) {
    _carrinho.removerProduto(produtoId);
  }

  void atualizarQuantidade(int produtoId, int novaQuantidade) {
    try {
      _carrinho.atualizarQuantidade(produtoId, novaQuantidade);
    } catch (e) {
      rethrow;
    }
  }

  void limparCarrinho() {
    _carrinho.limpar();
  }

  double get totalGeral => _carrinho.totalGeral;

  int get totalItens => _carrinho.totalItens;

  bool get carrinhoVazio => _carrinho.estaVazio;

  List<ItemCarrinho> get itens => _carrinho.itens;

  Future<bool> finalizarCompra() async {
    try {
      if (_carrinho.estaVazio) {
        throw Exception('Carrinho está vazio');
      }

      // Atualiza o estoque de cada produto
      for (var item in _carrinho.itens) {
        await _produtoController.atualizarEstoque(
          item.produto.id!,
          item.quantidade,
        );
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  String gerarNotaFiscal(Usuario usuario) {
    if (_carrinho.estaVazio) {
      return 'Carrinho vazio';
    }

    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('           NOTA FISCAL');
    buffer.writeln('========================================');
    buffer.writeln('');
    buffer.writeln('Cliente: ${usuario.nome}');
    buffer.writeln('CPF: ${_formatarCpf(usuario.cpf)}');
    buffer.writeln('');
    buffer.writeln('========================================');
    buffer.writeln('           PRODUTOS');
    buffer.writeln('========================================');
    buffer.writeln('');

    for (var item in _carrinho.itens) {
      buffer.writeln('${item.produto.nome}');
      buffer.writeln('  Qtd: ${item.quantidade} x ${_formatarPreco(item.produto.preco)}');
      buffer.writeln('  Subtotal: ${_formatarPreco(item.subtotal)}');
      buffer.writeln('');
    }

    buffer.writeln('========================================');
    buffer.writeln('TOTAL: ${_formatarPreco(_carrinho.totalGeral)}');
    buffer.writeln('========================================');
    buffer.writeln('');
    buffer.writeln('Obrigado pela preferência!');

    return buffer.toString();
  }

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String _formatarCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    }
    return cpf;
  }
}