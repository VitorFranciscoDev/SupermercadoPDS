import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_spec.dart';

class ProdutoUseCase implements IProdutoUseCase {
  ProdutoUseCase({ required this.produtoRepository });

  // repositório de produtos
  final ProdutoRepository produtoRepository;
  
  // função para validar o nome
  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  // função para validar o preço
  @override
  String? validarPreco(String preco) => preco.isEmpty ? "Preço não pode estar vazio" : null;

  // função para validar a quantidade
  @override
  String? validarQuantidade(String quantidade) => quantidade.isEmpty ? "Quantidade não pode estar vazia" : null;

  // função para cadastrar o produto
  @override
  Future<Produto?> cadastrarProduto(String nome, double preco, int quantidade) async {
    Produto produto = Produto(nome: nome, preco: preco, quantidade: quantidade);

    try {
      int result = await produtoRepository.registrarProduto(produto);

      if(result>0) return produto;
      return null;      
    } catch(e) {
      return null;
    }
  }

  // função para carregar os produtos
  Future<List<Produto>> carregarProdutos() async {
    try {
      return await produtoRepository.listarProdutos();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> excluirProduto(Produto produto) async {
    try {
      final result = await produtoRepository.excluirProduto(produto.id);
      
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> editarProduto(String nome, double preco, int quantidade) async {
    Produto produto = Produto(nome: nome, preco: preco, quantidade: quantidade);
    
    try {
      final result = await produtoRepository.editarProduto(produto);

      return result > 0;
    } catch (e) {
      return false;
    }
  }

}