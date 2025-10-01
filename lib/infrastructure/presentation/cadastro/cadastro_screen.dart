import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/infrastructure/presentation/app/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:supermercado/infrastructure/presentation/login/login_screen.dart';
import 'package:supermercado/modules/usuario/usuario_usecase.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  //Controllers de TextField
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  //Tipo do Usuário(usuário ou admin)
  TipoUsuario tipoUsuario = TipoUsuario.usuario;

  //Variáveis de erro dos TextFields
  String? erroNome;
  String? erroCPF;

  //Casos de Uso do Usuário
  final UsuarioUseCase usuarioUseCase = UsuarioUseCase(usuarioRepo: UsuarioRepository());

  //Função para cadastrar o usuário
  void cadastrar() async {
    //Variáveis de erro recebem a mensagem de erro
    setState(() {
      erroNome = usuarioUseCase.validarNome(controllerNome.text);
      erroCPF = usuarioUseCase.validarCPF(controllerCPF.text);
    });

    //Se não houver mensagem de erro, tenta fazer o cadastro
    if(erroNome==null && erroCPF==null) {
      final resultado = await usuarioUseCase.cadastrarUsuario(controllerNome.text, controllerCPF.text, tipoUsuario);

      if(resultado==null) {
        //Mensagem na tela
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
                          formatter: FilteringTextInputFormatter.digitsOnly,
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
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())), 
                              child: const Text("Clique aqui para ir ao Login!")
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