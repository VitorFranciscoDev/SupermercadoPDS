import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/produto_controller.dart';
import 'package:supermercado/controller/carrinho_controller.dart';
import 'package:supermercado/view/login_screen.dart';
import 'package:supermercado/controller/usuario_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioController()),
        ChangeNotifierProvider(create: (context) => ProdutoController()),
        ChangeNotifierProvider(create: (context) => CarrinhoController(produtoController: context.read<ProdutoController>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
