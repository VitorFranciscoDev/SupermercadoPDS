import 'package:supermercado/model/database/database_provider.dart';
import 'package:supermercado/model/produto.dart';

// classe abstrata com os contratos
abstract class IProdutoUseCase {
  String? validarNome(String nome);

  String? validarPreco(String preco);

  String? validarQuantidade(String quantidade);

  Future<Produto?> cadastrarProduto(String nome, double preco, int quantidade);

  Future<bool> editarProduto(Produto produto, String nome, double preco, int quantidade);

  Future<bool> excluirProduto(Produto produto);
}

class ProdutoRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  // função para registrar o produto no banco
  Future<int> registrarProduto(Produto produto) async {
    final db = await dbProvider.database;
    return await db.insert('produtos', produto.toMap());
  }

  // função para excluir o produto
  Future<int> excluirProduto(int? id) async {
    final db = await dbProvider.database;

    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  // função para editar o produto
  Future<int> editarProduto(Produto produto) async {
    final db = await dbProvider.database;

    return await db.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  } 

  // função para listar os produtos
  Future<List<Produto>> listarProdutos() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }
}

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
  Future<bool> editarProduto(Produto produto, String nome, double preco, int quantidade) async {
    Produto produtoEditado = Produto(id: produto.id, nome: nome, preco: preco, quantidade: quantidade);
    
    try {
      final result = await produtoRepository.editarProduto(produtoEditado);

      return result > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> atualizarQuantidade(Produto produto, int quantidade) async {
    Produto produtoAtualizado = Produto(
      nome: produto.nome,
      preco: produto.preco,
      quantidade: produto.quantidade - quantidade,
    );

    try {
      final result = await produtoRepository.editarProduto(produtoAtualizado);
      
      return result > 0;
    } catch (e) {
      return false;
    }
  }

}