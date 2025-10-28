import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/view/components/text_field_component.dart';
import 'package:supermercado/view/lista_produtos_screen.dart';
import 'package:supermercado/controller/carrinho_controller.dart';

class AdicionarCarrinhoDialog extends StatefulWidget {
  const AdicionarCarrinhoDialog({super.key, required this.produto});
  final Produto produto;

  @override
  State<AdicionarCarrinhoDialog> createState() => _AdicionarCarrinhoDialogState();
}

class _AdicionarCarrinhoDialogState extends State<AdicionarCarrinhoDialog> {
  TextEditingController controllerQuantidade = TextEditingController();
  int quantidade = 1;

  @override
  void initState() {
    super.initState();
    controllerQuantidade.text = quantidade.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.produto.nome),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 70, left: 70, top: 10),
            child: TextFieldComponent(
              controller: controllerQuantidade,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (quantidade < widget.produto.quantidade) {
                        quantidade++;
                        controllerQuantidade.text = quantidade.toString();
                      }
                    });
                  },
                  child: const Text("+"),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (quantidade > 1) {
                        quantidade--;
                        controllerQuantidade.text = quantidade.toString();
                      }
                    });
                  },
                  child: const Text("-"),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            final carrinhoProvider = context.read<CarrinhoController>();
            carrinhoProvider.adicionarItem(context, widget.produto, quantidade);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ListaProdutosScreen()));
          },
          child: const Text("Comprar"),
        ),
      ],
    );
  }
}
