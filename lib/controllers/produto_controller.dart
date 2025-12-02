import 'package:flutter/material.dart';
import 'package:supermercado/models/produtoDAO.dart';
import '../models/produto.dart';

class ProdutoController extends ChangeNotifier {
  final ProdutoDAO _produtoDAO = ProdutoDAO();
  
  List<Produto> _produtos = [];
  bool _isLoading = false;
  String? _mensagemErro;

  // Getters
  List<Produto> get produtos => _produtos;
  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;

  // Limpar mensagem de erro
  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }

  // Carregar todos os produtos
  Future<void> carregarProdutos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _produtos = await _produtoDAO.listarTodos();
      _mensagemErro = null;
    } catch (e) {
      _mensagemErro = 'Erro ao carregar produtos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cadastrar novo produto
  Future<bool> cadastrarProduto({
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
  }) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome do produto não pode estar vazio');
      }

      if (descricao.trim().isEmpty) {
        throw Exception('Descrição não pode estar vazia');
      }

      if (preco <= 0) {
        throw Exception('Preço deve ser maior que zero');
      }

      if (quantidadeEstoque < 0) {
        throw Exception('Quantidade em estoque não pode ser negativa');
      }

      final produto = Produto(
        nome: nome,
        descricao: descricao,
        preco: preco,
        quantidadeEstoque: quantidadeEstoque,
      );

      await _produtoDAO.inserir(produto);
      await carregarProdutos();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Atualizar produto
  Future<bool> atualizarProduto({
    required int id,
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
  }) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome do produto não pode estar vazio');
      }

      if (descricao.trim().isEmpty) {
        throw Exception('Descrição não pode estar vazia');
      }

      if (preco <= 0) {
        throw Exception('Preço deve ser maior que zero');
      }

      if (quantidadeEstoque < 0) {
        throw Exception('Quantidade em estoque não pode ser negativa');
      }

      final produto = Produto(
        id: id,
        nome: nome,
        descricao: descricao,
        preco: preco,
        quantidadeEstoque: quantidadeEstoque,
      );

      await _produtoDAO.atualizar(produto);
      await carregarProdutos();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Remover produto
  Future<bool> removerProduto(int id) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _produtoDAO.deletar(id);
      await carregarProdutos();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Buscar produto por ID
  Future<Produto?> buscarProduto(int id) async {
    return await _produtoDAO.buscarPorId(id);
  }

  // Atualizar estoque após compra
  Future<void> atualizarEstoque(int produtoId, int quantidadeVendida) async {
    try {
      final produto = await _produtoDAO.buscarPorId(produtoId);
      
      if (produto == null) {
        throw Exception('Produto não encontrado');
      }

      final novoEstoque = produto.quantidadeEstoque - quantidadeVendida;
      
      if (novoEstoque < 0) {
        throw Exception('Estoque insuficiente');
      }

      await _produtoDAO.atualizarEstoque(produtoId, novoEstoque);
      await carregarProdutos();
    } catch (e) {
      rethrow;
    }
  }

  // Formatar preço
  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}