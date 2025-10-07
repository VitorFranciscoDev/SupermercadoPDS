import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';

class ExcluirItemDialog extends StatefulWidget {
  const ExcluirItemDialog({super.key, required this.produto});
  final Produto produto;

  @override
  State<ExcluirItemDialog> createState() => _ExcluirItemDialogState();
}

class _ExcluirItemDialogState extends State<ExcluirItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Excluir Produto?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              context.read<ProdutoProvider>().excluirProduto(widget.produto);
              Navigator.of(context).pop();
            });
          }, 
          child: const Text("Remover"),
        ),
      ],
    );
  }
}