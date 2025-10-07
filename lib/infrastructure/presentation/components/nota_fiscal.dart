import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/carrinho_provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

class NotaFiscal extends StatelessWidget {
  const NotaFiscal({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.read<UsuarioProvider>().usuario;
    final carrinho = context.watch<CarrinhoProvider>().carrinho;
    final soma = context.watch<CarrinhoProvider>().somaTotal;

    return AlertDialog(
      title: const Text("Nota Fiscal"),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome: ${usuario!.nome}"),
            Text("CPF: ${usuario.cpf}"),
            const SizedBox(height: 10),
            const Text("Lista de Produtos:"),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: carrinho.length,
                itemBuilder: (context, index) {
                  final car = carrinho[index];
                  return Text(car.nome);
                },
              ),
            ),
            SizedBox(height: 10),
            Text("Total: R\$ $soma"),
          ],
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