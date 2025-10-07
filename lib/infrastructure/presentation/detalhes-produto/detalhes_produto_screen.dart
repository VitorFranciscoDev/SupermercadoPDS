import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/editar-produto-admin/editar_produto_admin_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

class DetalhesProdutoScreen extends StatefulWidget {
  const DetalhesProdutoScreen({ super.key, required this.produto });
  final Produto produto;

  @override
  State<DetalhesProdutoScreen> createState() => _DetalhesProdutoScreenState();
}

class _DetalhesProdutoScreenState extends State<DetalhesProdutoScreen> {
  @override
  Widget build(BuildContext context) {
    final tipo = context.read<UsuarioProvider>().usuario!.tipo;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text("Detalhes do Produto", 
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text("Nome: ${widget.produto.nome}", 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Quantidade: ${widget.produto.quantidade.toString()}", 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Text("Preço: ${widget.produto.preco.toString()}", 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: tipo == TipoUsuario.admin
        ? FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditarProdutoAdminScreen(produto: widget.produto))),
        child: Icon(Icons.edit, color: Colors.black),
      ) : null,
    );
  }
}