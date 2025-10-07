import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';

class ComprarItemDialog extends StatefulWidget {
  const ComprarItemDialog({super.key, required this.produto});
  final Produto produto;

  @override
  State<ComprarItemDialog> createState() => _ComprarItemDialogState();
}

class _ComprarItemDialogState extends State<ComprarItemDialog> {
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {

          }, 
          child: const Text("Comprar"),
        ),
      ],
    );
  }
}