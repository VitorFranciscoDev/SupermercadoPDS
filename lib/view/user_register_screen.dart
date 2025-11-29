import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/auth_controller.dart';
import 'package:supermercado/model/user.dart';
import 'package:supermercado/view/login_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  // Controllers
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerCPF = TextEditingController();

  // eh adm? (checkbox)
  bool isAdmin = false;

  // Limpa os Controllers
  void _clearFields() {
    setState(() {
      _controllerName.clear();
      _controllerCPF.clear();
      isAdmin = false;
    });
  }

  // Feedback na tela
  void _showSnackBar(bool isError, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error : Icons.check, color: isError ? Colors.red : Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text(title, style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Adiciona o Usuário no DB
  Future<void> addUser() async {
    final provider = context.read<AuthController>();

    final isValid = provider.validateFields(_controllerName.text, _controllerCPF.text);

    if(!isValid) return;

    final user = User(name: _controllerName.text, cpf: _controllerCPF.text, isAdmin: isAdmin);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await provider.addUser(user);

      Navigator.of(context).pop();

      if(result == null) {
        _showSnackBar(false, "Cadastro realizado com sucesso.");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        _clearFields();
      } else {
        _showSnackBar(true, "Erro no Cadastro.");
      }
    } catch(e) {
      _showSnackBar(true, "Erro inesperado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Supermercado",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                        suffixIcon: _controllerName.text.isEmpty
                          ? null 
                          : IconButton(
                            onPressed: () {
                              setState(() {
                                _controllerName.clear();
                              });
                            }, 
                            icon: Icon(Icons.clear, color: Color(0xFF2E7D32)),
                          ),
                        prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                        errorText: provider.errorName,
                        filled: true,
                        fillColor: Color(0xFFE8F5E9),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF81C784),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _controllerCPF,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: _controllerCPF.text.isEmpty
                          ? null 
                          : IconButton(
                            onPressed: () {
                              setState(() {
                                _controllerCPF.clear();
                              });
                            }, 
                            icon: Icon(Icons.clear, color: Color(0xFF2E7D32)),
                          ),
                        prefixIcon: Icon(Icons.badge, color: Color(0xFF2E7D32)),
                        labelText: "CPF",
                        labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                        errorText: provider.errorCPF,
                        filled: true,
                        fillColor: Color(0xFFE8F5E9),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF81C784),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF81C784),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tipo de conta",
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RadioListTile<bool>(
                            value: false,
                            groupValue: isAdmin,
                            onChanged: (value) {
                              setState(() {
                                isAdmin = value!;
                              });
                            },
                            title: Text(
                              "Cliente",
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            activeColor: Color(0xFF2E7D32),
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<bool>(
                            value: true,
                            groupValue: isAdmin,
                            onChanged: (value) {
                              setState(() {
                                isAdmin = value!;
                              });
                            },
                            title: Text(
                              "Admin",
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            activeColor: Color(0xFF2E7D32),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () => addUser(), 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color(0xFF2E7D32),
                        elevation: 5,
                        shadowColor: Color(0xFF2E7D32).withOpacity(0.5),
                      ),
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "Ou",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        _clearFields();
                        provider.clearErrors();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Clique aqui para fazer seu Login!",
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}