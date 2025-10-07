import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';

class ComprarItemDialog extends StatelessWidget {
  const ComprarItemDialog({ super.key, required this.produto });
  final Produto produto;
  TextEditingController controllerQuantidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(produto.nome),
      content: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: TextFieldComponent(
              controller: controllerQuantidade,
            ),
          ),
        ],
      ),
    );
  }
}