import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/usuario_controller.dart';
import '../utils/responsive_helper.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  bool _isAdministrador = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<UsuarioController>(context, listen: false);
    
    final sucesso = await controller.cadastrarUsuario(
      nome: _nomeController.text,
      cpf: _cpfController.text,
      isAdministrador: _isAdministrador,
    );

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cardWidth = ResponsiveHelper.getCardWidth(context);
    final padding = ResponsiveHelper.getPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
          ),
        ),
        elevation: 0,
      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Icon(
                                Icons.person_add,
                                size: isTablet ? 80 : 60,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            SizedBox(height: isTablet ? 24 : 16),
                            Center(
                              child: Text(
                                'Criar Nova Conta',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 40 : 32),
                            TextFormField(
                              controller: _nomeController,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(context, 16),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Nome Completo',
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
                            SizedBox(height: isTablet ? 28 : 24),
                            Container(
                              padding: EdgeInsets.all(isTablet ? 20 : 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipo de Conta',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getFontSize(context, 16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 12 : 8),
                                  SwitchListTile(
                                    title: Text(
                                      'Administrador',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(context, 15),
                                      ),
                                    ),
                                    subtitle: Text(
                                      _isAdministrador
                                          ? 'Pode gerenciar produtos'
                                          : 'Cliente comum',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(context, 13),
                                      ),
                                    ),
                                    value: _isAdministrador,
                                    onChanged: (value) {
                                      setState(() => _isAdministrador = value);
                                    },
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isTablet ? 32 : 24),
                            Consumer<UsuarioController>(
                              builder: (context, controller, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: isTablet ? 56 : 50,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading ? null : _cadastrar,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: controller.isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                            'CADASTRAR',
                                            style: TextStyle(
                                              fontSize: ResponsiveHelper.getFontSize(context, 16),
                                            ),
                                          ),
                                  ),
                                );
                              },
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