import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/infrastructure/presentation/app/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';
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
  //Controllers dos TextFields
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  //Variáveis de erro
  String? erroNome;
  String? erroCPF;

  //Casos de uso do usuário
  final UsuarioUseCase usuarioUseCase = UsuarioUseCase(usuarioRepo: UsuarioRepository());

  void entrar() async {
    setState(() {
      erroNome = usuarioUseCase.validarNome(controllerNome.text);
      erroCPF = usuarioUseCase.validarCPF(controllerCPF.text);
    });

    if(erroNome==null && erroCPF==null) {
      final resultado = await usuarioUseCase.fazerLogin(controllerNome.text, controllerCPF.text);

      if(resultado!=null) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("Login realizado com sucesso"),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<UsuarioProvider>().registrarUsuario(resultado);
                  Navigator.of(context).pop();
                  resultado.tipo==TipoUsuario.usuario ?
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListaProdutosScreen())) :
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdminScreen()));
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
                        formatter: FilteringTextInputFormatter.digitsOnly,
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