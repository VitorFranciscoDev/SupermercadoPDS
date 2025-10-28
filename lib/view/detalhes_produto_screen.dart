import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/enum_tipo_usuario.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/view/components/adicionar_carrinho_dialog.dart';
import 'package:supermercado/view/editar_produto_admin_screen.dart';
import 'package:supermercado/controller/usuario_controller.dart';

class DetalhesProdutoScreen extends StatefulWidget {
  const DetalhesProdutoScreen({ super.key, required this.produto });
  final Produto produto; // produto que será mostrado os detalhes

  @override
  State<DetalhesProdutoScreen> createState() => _DetalhesProdutoScreenState();
}

class _DetalhesProdutoScreenState extends State<DetalhesProdutoScreen> {
  late Produto produto;

  @override
  void initState() {
    super.initState();
    produto = widget.produto;
  }

  Future<void> irParaEdicao() async {
    final produtoEditado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarProdutoAdminScreen(produto: produto),
      ),
    );

    if (produtoEditado != null) {
      setState(() {
        produto = produtoEditado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // variável que recebe o tipo do usuário do provider
    final tipo = context.read<UsuarioController>().usuario!.tipo;

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
                      child: Text("Nome: ${produto.nome}", 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Preço: ${produto.preco.toString()}", 
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Text("Quantidade: ${produto.quantidade.toString()}", 
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
        onPressed: () => irParaEdicao(),
        child: Icon(Icons.edit, color: Colors.black),
      ) : FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => showDialog(context: context, builder: (context) => AdicionarCarrinhoDialog(produto: produto)),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}