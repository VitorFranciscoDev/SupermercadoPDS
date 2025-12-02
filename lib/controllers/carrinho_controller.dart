import 'package:flutter/material.dart';
import '../models/carrinho.dart';
import '../models/produto.dart';
import '../models/usuario.dart';

class CarrinhoController extends ChangeNotifier {
  final Carrinho _carrinho = Carrinho();
  String? _mensagemErro;

  // Getters
  Carrinho get carrinho => _carrinho;
  List<ItemCarrinho> get itens => _carrinho.itens;
  double get totalGeral => _carrinho.totalGeral;
  int get totalItens => _carrinho.totalItens;
  bool get carrinhoVazio => _carrinho.estaVazio;
  String? get mensagemErro => _mensagemErro;

  // Limpar mensagem de erro
  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }

  // Adicionar produto ao carrinho
  bool adicionarProduto(Produto produto, int quantidade) {
    try {
      _carrinho.adicionarProduto(produto, quantidade);
      _mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Remover produto do carrinho
  void removerProduto(int produtoId) {
    _carrinho.removerProduto(produtoId);
    notifyListeners();
  }

  // Atualizar quantidade de um produto
  bool atualizarQuantidade(int produtoId, int novaQuantidade) {
    try {
      _carrinho.atualizarQuantidade(produtoId, novaQuantidade);
      _mensagemErro = null;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Limpar carrinho
  void limparCarrinho() {
    _carrinho.limpar();
    notifyListeners();
  }

  // Verificar se produto está no carrinho
  bool produtoNoCarrinho(int produtoId) {
    return _carrinho.itens.any((item) => item.produto.id == produtoId);
  }

  // Obter quantidade de um produto no carrinho
  int obterQuantidadeProduto(int produtoId) {
    try {
      final item = _carrinho.itens.firstWhere(
        (item) => item.produto.id == produtoId,
      );
      return item.quantidade;
    } catch (e) {
      return 0;
    }
  }

  // Gerar nota fiscal
  String gerarNotaFiscal(Usuario usuario) {
    if (_carrinho.estaVazio) {
      return 'Carrinho vazio';
    }

    final buffer = StringBuffer();
    final dataHora = DateTime.now();
    
    buffer.writeln('========================================');
    buffer.writeln('           NOTA FISCAL');
    buffer.writeln('========================================');
    buffer.writeln('');
    buffer.writeln('Data: ${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year}');
    buffer.writeln('Hora: ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}');
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
    buffer.writeln('Total de itens: ${_carrinho.totalItens}');
    buffer.writeln('TOTAL A PAGAR: ${_formatarPreco(_carrinho.totalGeral)}');
    buffer.writeln('========================================');
    buffer.writeln('');
    buffer.writeln('Obrigado pela preferência!');

    return buffer.toString();
  }

  // Formatar preço
  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Formatar CPF
  String _formatarCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    }
    return cpf;
  }
}