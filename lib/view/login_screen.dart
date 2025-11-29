import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/auth_controller.dart';
import 'package:supermercado/view/bottom_navigator.dart';
import 'package:supermercado/view/user_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerCPF = TextEditingController();
  
  // Limpa os Controllers
  void _clearFields() {
    setState(() {
      _controllerName.clear();
      _controllerCPF.clear();
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

  // Tenta o Login
  Future<void> doLogin() async {
    final provider = context.read<AuthController>();

    final isValid = provider.validateFields(_controllerName.text, _controllerCPF.text);

    if(!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await provider.doLogin(_controllerName.text, _controllerCPF.text);

      Navigator.of(context).pop();

      if(result == null) {
        _showSnackBar(false, "Login feito com sucesso");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigator()));
        _clearFields();
      } else {
        _showSnackBar(true, "Email ou Senha Inválidos.");
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
        
                    const SizedBox(height: 25),
        
                    ElevatedButton(
                      onPressed: () => doLogin(), 
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
                        "Entrar",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserRegisterScreen()));
                        _clearFields();
                        provider.clearErrors();
                      }, 
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Clique aqui para fazer seu cadastro!",
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
            ],
          ),
        ),
      ),
    );
  }
}