import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/usuario_controller.dart';
import '../utils/responsive_helper.dart';
import 'cadastro_usuario_view.dart';
import 'cadastro_produto_view.dart';
import 'compra_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<UsuarioController>(context, listen: false);
    
    final sucesso = await controller.fazerLogin(
      _nomeController.text,
      _cpfController.text,
    );

    if (sucesso && mounted) {
      final usuario = controller.usuarioLogado;
      if (usuario != null) {
        if (usuario.isAdministrador) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroProdutoView(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CompraView(),
            ),
          );
        }
      }
    } else if (mounted && controller.mensagemErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.mensagemErro!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroUsuarioView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cardWidth = ResponsiveHelper.getCardWidth(context);
    final padding = ResponsiveHelper.getPadding(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: padding,
              child: Center(
                child: SizedBox(
                  width: cardWidth,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: isTablet 
                          ? const EdgeInsets.all(48.0) 
                          : const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              size: isTablet ? 100 : 80,
                              color: Colors.blue.shade700,
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Text(
                              'Supermercado Manager',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, 24),
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            Text(
                              'Faça login para continuar',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, 14),
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: isTablet ? 40 : 32),
                            TextFormField(
                              controller: _nomeController,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, 16),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe seu nome';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            TextFormField(
                              controller: _cpfController,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, 16),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'CPF',
                                prefixIcon: Icon(Icons.badge),
                                border: OutlineInputBorder(),
                                hintText: '000.000.000-00',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe seu CPF';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: isTablet ? 32 : 24),
                            Consumer<UsuarioController>(
                              builder: (context, controller, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: isTablet ? 56 : 50,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading ? null : _fazerLogin,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: controller.isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                            'ENTRAR',
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper.getFontSize(context, 16),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            TextButton(
                              onPressed: _irParaCadastro,
                              child: Text(
                                'Não tem conta? Cadastre-se',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}