import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/infrastructure/presentation/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/components/text_field_component.dart';
import 'package:supermercado/infrastructure/presentation/cadastro/cadastro_screen.dart';
import 'package:supermercado/infrastructure/presentation/home-admin/home_admin_screen.dart';
import 'package:supermercado/infrastructure/presentation/lista-produtos/lista_produtos_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';
import 'package:supermercado/modules/usuario/usuario_usecase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers dos TextFields
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  // variáveis de erro
  String? erroNome;
  String? erroCPF;

  final UsuarioUseCase usuarioUseCase = UsuarioUseCase(usuarioRepo: UsuarioRepository()); // casos de uso do usuário

  // função para o usuário logar no app
  Future<void> entrar() async {

    // variáveis de erro
    setState(() {
      erroNome = usuarioUseCase.validarNome(controllerNome.text);
      erroCPF = usuarioUseCase.validarCPF(controllerCPF.text);
    });

    // caso não haja erros, tenta logar
    if(erroNome==null && erroCPF==null) {
      final resultado = await usuarioUseCase.fazerLogin(controllerNome.text, controllerCPF.text);

      if(resultado!=null) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Bem vindo de volta!"),
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
        context.read<UsuarioProvider>().registrarUsuario(resultado);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
          resultado.tipo == TipoUsuario.usuario
            ? ListaProdutosScreen()
            : HomeAdminScreen(),
          ),
        );
      } else {
        // mensagem na tela
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
      body: SingleChildScrollView(
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
                        tipo: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: ButtonComponent(
                        metodo: entrar,
                        mensagem: "Entrar",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Column(
                        children: [
                          const Text("Ainda não tem uma conta?"),
                          TextButton(
                            // navega para a tela de cadastro
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