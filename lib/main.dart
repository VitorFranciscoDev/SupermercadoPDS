import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/usuario_controller.dart';
import 'controllers/produto_controller.dart';
import 'controllers/carrinho_controller.dart';
import 'views/login_view.dart';

void main() {
  runApp(const SupermercadoApp());
}

class SupermercadoApp extends StatelessWidget {
  const SupermercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioController()),
        ChangeNotifierProvider(create: (_) => ProdutoController()),
        ChangeNotifierProvider(create: (_) => CarrinhoController()),
      ],
      child: MaterialApp(
        title: 'Supermercado Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginView(),
      ),
    );
  }
}