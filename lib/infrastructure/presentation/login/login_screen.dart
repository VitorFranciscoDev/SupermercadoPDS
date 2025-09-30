import 'package:flutter/material.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/infrastructure/presentation/app/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:supermercado/infrastructure/presentation/cadastro/cadastro_screen.dart';
import 'package:supermercado/infrastructure/presentation/home_admin/home_admin_screen.dart';
import 'package:supermercado/infrastructure/presentation/home_usuario/home_user_screen.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  String? erroNome;
  String? erroCPF;

  final UsuarioRepository usuarioRepo = UsuarioRepository();

  void logar() async {
    setState(() {
      if(controllerNome.text.isEmpty) {
        erroNome = "Nome não pode estar em branco";
      } else {
        erroNome = null;
      }

      if(controllerCPF.text.isEmpty) {
        erroCPF = "CPF não pode estar em branco";
      } else if(controllerCPF.text.length!=11) {
        erroCPF = "CPF deve conter 11 dígitos";
      } else {
        erroCPF = null;
      }
    });

    if(erroNome==null && erroCPF==null) {
      Usuario? usuario = await usuarioRepo.verificarLogin(controllerNome.text, int.parse(controllerCPF.text));
      if(usuario!=null) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Login realizado com sucesso"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if(usuario.tipo==TipoUsuario.usuario) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeUserScreen()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdminScreen()));
                  }
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Nome ou CPF inválidos"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar"),
              ),
            ],
          ),
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
              child: const Text("Login", 
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
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: ButtonComponent(
                        metodo: logar,
                        mensagem: "Entrar",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Column(
                        children: [
                          const Text("Ainda não tem uma conta?"),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroScreen())), 
                            child: const Text("Clique aqui para ir ao Cadastro!")
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