import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_spec.dart';

class ProdutoUseCase implements IProdutoUseCase {
  ProdutoUseCase({ required this.produtoRepo });

  //Repositório de produtos
  final ProdutoRepository produtoRepo;
  
  //Função para validar o nome
  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  //Função para validar o preço
  @override
  String? validarPreco(String preco) => preco.isEmpty ? "Preço não pode estar vazio" : null;

  //Função para validar a quantidade
  @override
  String? validarQuantidade(String quantidade) => quantidade.isEmpty ? "Quantidade não pode estar vazia" : null;

  @override
  Future<Produto?> cadastrarProduto(String nome, double preco, int quantidade) async {
    Produto produto = Produto(nome: nome, preco: preco, quantidade: quantidade);

    try {
      int result = await produtoRepo.registrarProduto(produto);

      if(result>0) {
        return produto;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<Produto?> editarProduto(Produto produtoVelho, Produto produtoNovo) async {
    
  }
}