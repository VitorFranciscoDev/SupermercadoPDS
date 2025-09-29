import 'package:flutter/material.dart';

class DetalhesProdutoUsuarioScreen extends StatelessWidget {
  const DetalhesProdutoUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: const Text("Detalhes"),
            ),
          ],
        ),
      ),
    );
  }
}