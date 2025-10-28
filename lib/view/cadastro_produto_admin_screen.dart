import 'package:flutter/material.dart';
import 'package:supermercado/model/produtoDAO.dart';
import 'package:supermercado/view/components/button_component.dart';
import 'package:supermercado/view/components/text_field_component.dart';

class CadastroProdutoAdminScreen extends StatefulWidget {
  const CadastroProdutoAdminScreen({super.key});

  @override
  State<CadastroProdutoAdminScreen> createState() => _CadastroProdutoAdminScreenState();
}

class _CadastroProdutoAdminScreenState extends State<CadastroProdutoAdminScreen> {
  
  // controllers do TextField
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerPreco = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();

  // variáveis de erro
  String? erroNome;
  String? erroPreco;
  String? erroQuantidade;

  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository()); // casos de uso da aplicação

  // função para cadastrar o produto
  Future<void> cadastrarProduto() async {
    setState(() {
      erroNome = produtoUseCase.validarNome(controllerNome.text);
      erroPreco = produtoUseCase.validarPreco(controllerPreco.text);
      erroQuantidade = produtoUseCase.validarQuantidade(controllerQuantidade.text);
    });

    if(erroNome==null && erroPreco==null && erroQuantidade==null) {
      final resultado = await produtoUseCase.cadastrarProduto(controllerNome.text, double.parse(controllerPreco.text), int.parse(controllerQuantidade.text));

      if(resultado!=null) {
        // mensagem na tela
        showDialog(
          context: context, builder: (context) {
            return AlertDialog(
              title: const Text("Produto Cadastrado"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop, 
                  child: const Text("Fechar"),
                ),
              ],
            );
          }
        );
      } else {
        // mensagem na tela
        showDialog(
          context: context, builder: (context) {
            return AlertDialog(
              title: Text("Erro no cadastro do produto"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop, 
                  child: const Text("Fechar"),
                ),
              ],
            );
          }
        );
      }
    }
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
                controller: controllerPreco,
                hint: "Preço do Produto",
                erro: erroPreco,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 40, left: 40),
              child: TextFieldComponent(
                controller: controllerQuantidade,
                hint: "Quantidade em Estoque",
                erro: erroQuantidade,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, right: 40, left: 40),
              child: ButtonComponent(
                metodo: cadastrarProduto, 
                mensagem: "Cadastrar",
              ),
            ),
          ],
        ),
      ),
    );
  }
}