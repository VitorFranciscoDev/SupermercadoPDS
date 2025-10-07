import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/presentation/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {

  void comprarItens() {

  }

  @override
  Widget build(BuildContext context) {
    final produtos = context.watch<ProdutoProvider>().produtos;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100, bottom: 30),
              child: const Text(
                "Carrinho de Compras",
                style: TextStyle(fontSize: 30, fontFamily: "Arial"),
              ),
            ),
            Container(
              width: 300,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: produtos.isNotEmpty
                ? ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: Container(
                        width: 300,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Text(
                                produto.nome,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Text(
                              "Preço: ${produto.preco}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    const Text("Sem Produtos no Carrinho",
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30, right: 50, left: 50),
              child: ButtonComponent(
                metodo: comprarItens, 
                mensagem: "Comprar Itens",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
