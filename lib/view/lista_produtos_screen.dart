import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/enum_tipo_usuario.dart';
import 'package:supermercado/view/components/excluir_item_dialog.dart';
import 'package:supermercado/view/carrinho_screen.dart';
import 'package:supermercado/view/detalhes_produto_screen.dart';
import 'package:supermercado/view/login_screen.dart';
import 'package:supermercado/controller/produto_controller.dart';
import 'package:supermercado/controller/usuario_controller.dart';

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
    context.read<ProdutoController>().carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    // tipo de usuário e a lista de produtos
    final tipo = context.read<UsuarioController>().usuario!.tipo;
    final produtos = context.watch<ProdutoController>().produtos;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: tipo == TipoUsuario.usuario
      ? AppBar(
        backgroundColor: Colors.black,
        title: const Text("Produtos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())); 
          },
        ),
      ) : null,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
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