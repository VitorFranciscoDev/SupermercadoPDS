import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/controller/produto_controller.dart';
import 'package:supermercado/model/produtoDAO.dart';

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
          onPressed: () async {
            // remove o produto
            await produtoUseCase.excluirProduto(widget.produto);
            Navigator.of(context).pop();
            context.read<ProdutoController>().carregarProdutos();
          }, 
          child: const Text("Remover"),
        ),
      ],
    );
  }
}