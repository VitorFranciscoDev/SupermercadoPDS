import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/infrastructure/presentation/app/components/comprar_item_dialog.dart';
import 'package:supermercado/infrastructure/presentation/detalhes-produto/detalhes_produto_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

class ListaProdutosScreen extends StatefulWidget {
  const ListaProdutosScreen({super.key});

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  bool modoCompra = false;

  @override
  Widget build(BuildContext context) {
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
                          if(modoCompra) {
                            showDialog(context: context, builder: (context) => ComprarItemDialog(produto: produto));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesProdutoScreen(produto: produto)));
                          }
                        },
                        child: Container(
                          width: 300,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 180),
                                child: Text(produto.nome, 
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                              ),
                              Text(produto.preco.toString()),
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
      floatingActionButton: tipo == TipoUsuario.usuario ?
       FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            modoCompra = !modoCompra;
          });
        },
        child: Icon(Icons.shopping_cart, color: Colors.black),  
      ) : null,
    );
  }
}