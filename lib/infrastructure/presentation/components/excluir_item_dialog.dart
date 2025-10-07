import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_usecase.dart';

class ExcluirItemDialog extends StatefulWidget {
  const ExcluirItemDialog({super.key, required this.produto});
  final Produto produto; // produto que será excluído

  @override
  State<ExcluirItemDialog> createState() => _ExcluirItemDialogState();
}

class _ExcluirItemDialogState extends State<ExcluirItemDialog> {
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository()); // casos de uso do produto

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Excluir Produto?"),
      actions: [
        TextButton(
          // sai do alert
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              // remove o produto
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