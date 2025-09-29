import 'package:flutter/material.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerPreco = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();

  String? erroNome;
  String? erroPreco;
  String? erroQuantidade;

  void cadastrarProduto() {
    setState(() {
      if(controllerNome.text.isEmpty) {
        erroNome = "Nome não pode estar vazio";
      } else if(!RegExp(r'^[a-zA-Z]+$').hasMatch(controllerNome.text)) {
        erroNome = "Nome deve ter apenas letras";
      } else {
        erroNome = null;
      }

      if(controllerPreco.text.isEmpty) {
        erroPreco = "Preço não pode estar vazio";
      } else if(!RegExp(r'^[1-9]+$').hasMatch(controllerPreco.text)) {
        erroPreco = "Preço deve ter apenas números";
      } else {
        erroPreco = null;
      }

      if(controllerQuantidade.text.isEmpty) {
        erroQuantidade = "Quantidade não pode estar vazio";
      } else if(!RegExp(r'^[1-9]+$').hasMatch(controllerQuantidade.text)) {
        erroQuantidade = "Quantidade deve ter apenas números";
      } else {
        erroQuantidade = null;
      }
    });

    //if(erroNome)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: const Text("Cadastro de Produto",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 40, left: 40),
              child: TextFieldComponent(
                controller: controllerNome,
                hint: "Nome do Produto",
                erro: erroNome,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 40, left: 40),
              child: TextFieldComponent(
                controller: controllerNome,
                hint: "Nome do Produto",
                erro: erroNome,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 40, left: 40),
              child: TextFieldComponent(
                controller: controllerNome,
                hint: "Nome do Produto",
                erro: erroNome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}