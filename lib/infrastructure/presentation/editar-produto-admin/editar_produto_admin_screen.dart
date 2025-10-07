import 'package:flutter/material.dart';
import 'package:supermercado/entities/produto.dart';
import 'package:supermercado/infrastructure/presentation/app/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:supermercado/modules/produto/produto_repository.dart';
import 'package:supermercado/modules/produto/produto_usecase.dart';

class EditarProdutoAdminScreen extends StatefulWidget {
  const EditarProdutoAdminScreen({ super.key, required this.produto });
  final Produto produto;

  @override
  State<EditarProdutoAdminScreen> createState() => _EditarProdutoAdminScreenState();
}

class _EditarProdutoAdminScreenState extends State<EditarProdutoAdminScreen> {
  //Controllers do TextField
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerPreco = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();

  //Variáveis de erro
  String? erroNome;
  String? erroPreco;
  String? erroQuantidade;

  //Casos de uso da aplicação
  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository());

  @override
  void initState() {
    super.initState();
    controllerNome.text = widget.produto.nome;
    controllerPreco.text = widget.produto.preco.toString();
    controllerQuantidade.text = widget.produto.quantidade.toString();
  }

  void editarProduto() async {
    setState(() {
      erroNome = produtoUseCase.validarNome(controllerNome.text);
      erroPreco = produtoUseCase.validarPreco(controllerPreco.text);
      erroQuantidade = produtoUseCase.validarQuantidade(controllerQuantidade.text);
    });

    if(erroNome==null && erroPreco==null && erroQuantidade==null) {
      final resultado = await produtoUseCase.cadastrarProduto(controllerNome.text, double.parse(controllerPreco.text), int.parse(controllerQuantidade.text));

      if(resultado!=null) {
        showDialog(
          context: context, builder: (context) {
            return AlertDialog(
              title: const Text("Produto Editado"),
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
        showDialog(
          context: context, builder: (context) {
            return AlertDialog(
              title: Text("Erro na edição do produto"),
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
              child: const Text("Editar Produto",
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
                metodo: editarProduto, 
                mensagem: "Editar",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
