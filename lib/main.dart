import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/carrinho_provider.dart';
import 'package:supermercado/infrastructure/presentation/login/login_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => ProdutoProvider()),
        ChangeNotifierProvider(create: (context) => CarrinhoProvider(produtoProvider: context.read<ProdutoProvider>())),
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
