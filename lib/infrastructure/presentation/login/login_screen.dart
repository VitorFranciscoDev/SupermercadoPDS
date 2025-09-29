import 'package:flutter/material.dart';
import 'package:supermercado/entities/enum_tipo.dart';
import 'package:supermercado/infrastructure/presentation/app/components/button_component.dart';
import 'package:supermercado/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:supermercado/infrastructure/presentation/home_admin/home_admin_screen.dart';
import 'package:supermercado/infrastructure/presentation/home_user/home_user_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();

  Tipo tipoUsuario = Tipo.usuario;

  String? erroNome;
  String? erroCPF;

  void cadastrar() {
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
      if(tipoUsuario==Tipo.usuario) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeUserScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdminScreen()));
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
              child: const Text("Supermercado", 
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
                      padding: EdgeInsets.only(top: 20, right: 40, left: 40),
                      child: Column( 
                        children: [
                          ListTile(
                            title: const Text("Usuário"),
                            leading: Radio(
                              value: Tipo.usuario,
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
                              value: Tipo.admin,
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
                        mensagem: "Entrar",
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 40)),
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