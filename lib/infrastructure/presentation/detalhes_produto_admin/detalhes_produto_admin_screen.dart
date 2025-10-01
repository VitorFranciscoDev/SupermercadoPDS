import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/editar_produto_admin_screen/editar_produto_admin_screen.dart';

class DetalhesProdutoAdminScreen extends StatefulWidget {
  const DetalhesProdutoAdminScreen({ super.key, required this.produto });
  final Produto produto;

  @override
  State<DetalhesProdutoAdminScreen> createState() => _DetalhesProdutoAdminScreenState();
}

class _DetalhesProdutoAdminScreenState extends State<DetalhesProdutoAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150),
              child: Text(widget.produto.nome, 
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 200),
              child: Text("Quantidade: ${widget.produto.quantidade.toString()}", 
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 255),
              child: Text("Preço: ${widget.produto.preco.toString()}", 
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
        //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditarProdutoAdminScreen())),
        //child: Icon(Icons.edit),
      //),
    );
  }
}