import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/infrastructure/presentation/components/excluir_item_dialog.dart';
import 'package:supermercado/infrastructure/presentation/carrinho/carrinho_screen.dart';
import 'package:supermercado/infrastructure/presentation/detalhes-produto/detalhes_produto_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

class ListaProdutosScreen extends StatefulWidget {
  const ListaProdutosScreen({super.key});

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  bool modoExcluir = false; // função para alternar a tela quando o usuário clicar no botão

  // carrega os produtos do db
  @override
  void initState() {
    super.initState();
    context.read<ProdutoProvider>().carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    // tipo de usuário e a lista de produtos
    final tipo = context.read<UsuarioProvider>().usuario!.tipo;
    final produtos = context.watch<ProdutoProvider>().produtos;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: const Text("Produtos Disponíveis", 
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Arial",
                ),
              ),
            ),
            produtos.isNotEmpty 
              ? Expanded(
                child: ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 30, right: 40, left: 40),
                      child: GestureDetector(
                        onTap: () {
                          // se a variável for true, chama o dialog de excluir o item, senão navega para a lista de detalhes do produto
                          modoExcluir ? showDialog(context: context, builder: (context) => ExcluirItemDialog(produto: produto))
                          : Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesProdutoScreen(produto: produto)));
                        },
                        child: Container(
                          width: 300,
                          height: 70,
                          decoration: BoxDecoration(
                            color: modoExcluir ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 10),
                                child: Text(produto.nome, 
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Text("Preço: ${produto.preco}", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    const Text("Sem produtos na lista", 
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    const Text("Volte outra hora", 
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: tipo == TipoUsuario.admin ?
       FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            modoExcluir = !modoExcluir;
          });
        },
        child: Icon(Icons.delete, color: Colors.black),  
      ) : FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CarrinhoScreen())),
        child: Icon(Icons.shopping_cart, color: Colors.black),
      ),
    );
  }
}