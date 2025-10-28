import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/controller/usuario_controller.dart';

class NotaFiscal extends StatelessWidget {
  final List<Produto> carrinho; // itens no momento da compra

  const NotaFiscal({super.key, required this.carrinho});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<UsuarioController>().usuario;
    final soma = carrinho.fold<double>(0, (total, item) => total + item.preco * item.quantidade);

    return AlertDialog(
      title: const Text("Nota Fiscal"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome: ${usuario?.nome}"),
            Text("CPF: ${usuario?.cpf}"),
            const SizedBox(height: 10),
            const Text("Lista de Produtos:"),
            const SizedBox(height: 5),
            SizedBox(
              height: carrinho.length * 20,
              child: ListView.builder(
                itemCount: carrinho.length,
                itemBuilder: (context, index) {
                  final produto = carrinho[index];
                  return Text(
                    "${produto.nome} x${produto.quantidade} - R\$ ${produto.preco * produto.quantidade}",
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text("Total: R\$ $soma"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
