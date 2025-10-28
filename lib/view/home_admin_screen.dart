import 'package:flutter/material.dart';
import 'package:supermercado/view/cadastro_produto_admin_screen.dart';
import 'package:supermercado/view/lista_produtos_screen.dart';
import 'package:supermercado/view/login_screen.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Produtos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())); 
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: const Text("Tela Inicial", 
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 70, left: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                // navega para a tela da lista de produtos
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListaProdutosScreen())),
                child: const Text("Lista de Produtos", style: TextStyle(color: Colors.black)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, right: 70, left: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                // navega para a tela de cadastro de produtos
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroProdutoAdminScreen())),
                child: const Text("Adicionar Produto", style: TextStyle(color: Colors.black))
              ),
            ),
          ],
        ),
      ),
    );
  }
}