import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/components/text_field_component.dart';
import 'package:supermercado/infrastructure/presentation/lista-produtos/lista_produtos_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/carrinho_provider.dart';

class AdicionarCarrinhoDialog extends StatefulWidget {
  const AdicionarCarrinhoDialog({super.key, required this.produto});
  final Produto produto; // produto que será adicionado ao carrinho

  @override
  State<AdicionarCarrinhoDialog> createState() => _AdicionarCarrinhoDialogState();
}

class _AdicionarCarrinhoDialogState extends State<AdicionarCarrinhoDialog> {
  TextEditingController controllerQuantidade = TextEditingController(); // controller do textfield

  int quantidade = 1; // quantidade inicial do carrinho
  
  // quando a página for aberta, o texto do text field será a variável quantidade
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
            padding: EdgeInsets.only(right: 70, left: 70, top: 10),
            child: TextFieldComponent(
              controller: controllerQuantidade,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // aumenta a quantidade
                      if(quantidade<widget.produto.quantidade) {
                        quantidade++;
                        controllerQuantidade.text = quantidade.toString();
                      }
                    });
                  }, 
                  child: const Text("+"),
                ),
                Padding(padding: EdgeInsets.only(right: 5)),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // diminui a quantidade
                      if(quantidade>0) {
                        quantidade--;
                        controllerQuantidade.text = quantidade.toString();
                      }
                    });
                  }, 
                  child: const Text("-")
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          // sai do alert
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            context.read<CarrinhoProvider>().adicionarItem(widget.produto, quantidade);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListaProdutosScreen()));
          }, 
          child: const Text("Comprar"),
        ),
      ],
    );
  }
}