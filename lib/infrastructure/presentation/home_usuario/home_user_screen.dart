import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            produtos.isEmpty ?
              Expanded(
                child: ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 30, right: 40, left: 40),
                      child: Container(
                        width: 300,
                        height: 70,
                        decoration: BoxDecoration(
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
                    );
                  },
                ),
              )
              : Padding(padding: EdgeInsets.only(top: 100)),
              const Text("Sem produtos na lista", 
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}