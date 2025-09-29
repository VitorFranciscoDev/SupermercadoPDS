import 'package:flutter/material.dart';

class ListaProdutosAdminScreen extends StatelessWidget {
  const ListaProdutosAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.only(top: 30),
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
                      child: const Text("Nome", 
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    const Text("Preço")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}