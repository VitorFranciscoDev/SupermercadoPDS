import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/model/produto.dart';
import 'package:supermercado/model/produtoDAO.dart';
import 'package:supermercado/view/components/button_component.dart';
import 'package:supermercado/view/components/text_field_component.dart';
import 'package:supermercado/controller/produto_controller.dart';

class EditarProdutoAdminScreen extends StatefulWidget {
  const EditarProdutoAdminScreen({ super.key, required this.produto });
  final Produto produto; // produto que será editado

  @override
  State<EditarProdutoAdminScreen> createState() => _EditarProdutoAdminScreenState();
}

class _EditarProdutoAdminScreenState extends State<EditarProdutoAdminScreen> {
  
  // controllers do TextField
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerPreco = TextEditingController();
  TextEditingController controllerQuantidade = TextEditingController();

  // variáveis de erro
  String? erroNome;
  String? erroPreco;
  String? erroQuantidade;

  final ProdutoUseCase produtoUseCase = ProdutoUseCase(produtoRepository: ProdutoRepository()); // casos de uso do produto

  // quando a página for aberta, os text fields já começarão preenchidos com as informações do produto
  @override
  void initState() {
    super.initState();
    controllerNome.text = widget.produto.nome;
    controllerPreco.text = widget.produto.preco.toString();
    controllerQuantidade.text = widget.produto.quantidade.toString();
  }

  // função para editar o produto
  Future<void> editarProduto() async {

    // variáveis de erro
    setState(() {
      erroNome = produtoUseCase.validarNome(controllerNome.text);
      erroPreco = produtoUseCase.validarPreco(controllerPreco.text);
      erroQuantidade = produtoUseCase.validarQuantidade(controllerQuantidade.text);
    });

    // se não houver erros, tenta editar o produto
    if(erroNome==null && erroPreco==null && erroQuantidade==null) {
      final resultado = await produtoUseCase.editarProduto(widget.produto, controllerNome.text, double.parse(controllerPreco.text), int.parse(controllerQuantidade.text));

      if(resultado) {
        Produto produtoAtualizado = Produto(
          id: widget.produto.id,
          nome: controllerNome.text,
          preco: double.parse(controllerPreco.text),
          quantidade: int.parse(controllerQuantidade.text),
        );
        Navigator.of(context).pop(produtoAtualizado);          
        context.read<ProdutoController>().carregarProdutos();
      } else {
        // mensagem na tela
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
