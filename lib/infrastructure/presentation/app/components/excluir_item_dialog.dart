import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_usecase.dart';

class ExcluirItemDialog extends StatefulWidget {
  const ExcluirItemDialog({super.key, required this.produto});
  final Produto produto;

  @override
  State<ExcluirItemDialog> createState() => _ExcluirItemDialogState();
}

class _ExcluirItemDialogState extends State<ExcluirItemDialog> {
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository());

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
              produtoUseCase.excluirProduto(widget.produto);
              Navigator.of(context).pop();
            });
          }, 
          child: const Text("Remover"),
        ),
      ],
    );
  }
}