import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supermercado/model/enum_tipo_usuario.dart';
import 'package:supermercado/model/usuarioDAO.dart';
import 'package:supermercado/view/components/button_component.dart';
import 'package:supermercado/view/components/text_field_component.dart';
import 'package:supermercado/view/login_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  
  // controllers de TextField
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  TipoUsuario tipoUsuario = TipoUsuario.usuario; // tipo do usuário

  // variáveis de erro dos textfields
  String? erroNome;
  String? erroCPF;

  final UsuarioUseCase usuarioUseCase = UsuarioUseCase(usuarioRepo: UsuarioRepository()); // casos de uso do usuário

  // função para cadastrar o usuário
  void cadastrar() async {

    // variáveis recebem a mensagem de erro
    setState(() {
      erroNome = usuarioUseCase.validarNome(controllerNome.text);
      erroCPF = usuarioUseCase.validarCPF(controllerCPF.text);
    });

    // se não houver mensagem de erro, tenta fazer o cadastro
    if(erroNome==null && erroCPF==null) {
      final resultado = await usuarioUseCase.cadastrarUsuario(controllerNome.text, controllerCPF.text, tipoUsuario);

      if(resultado==null) {
        // mensagem na tela
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Usuário cadastrado!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }, 
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      } else {
        // mensagem de erro caso dê algum problema no cadastro
        setState(() {
          erroCPF = resultado;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: const Text("Cadastro", 
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Arial",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 30, left: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40, right: 40, left: 40),
                        child: TextFieldComponent(
                          controller: controllerNome,
                          hint: "Nome",
                          erro: erroNome,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 40, left: 40),
                        child: TextFieldComponent(
                          controller: controllerCPF,
                          hint: "CPF",
                          erro: erroCPF,
                          tipo: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, right: 40, left: 40),
                        child: Column( 
                          children: [
                            ListTile(
                              title: const Text("Usuário"),
                              leading: Radio(
                                value: TipoUsuario.usuario,
                                groupValue: tipoUsuario,
                                onChanged: (novoTipo) {
                                  setState(() {
                                    tipoUsuario = novoTipo!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("Admin"),
                              leading: Radio(
                                value: TipoUsuario.admin,
                                groupValue: tipoUsuario,
                                onChanged: (novoTipo) {
                                  setState(() {
                                    tipoUsuario = novoTipo!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                        child: ButtonComponent(
                          metodo: cadastrar,
                          mensagem: "Cadastrar",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                        child: Column(
                          children: [
                            const Text("Já tem uma conta?"),
                            TextButton(
                              // navega para a página de login
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())), 
                              child: const Text("Clique aqui para ir ao Login!"),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 25)),
                    ],                  
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}