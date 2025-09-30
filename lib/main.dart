import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';
import 'package:supermercado/infrastructure/presentation/login/login_screen.dart';
import 'package:supermercado/infrastructure/presentation/providers/produto_provider.dart';
import 'package:supermercado/infrastructure/presentation/providers/usuario_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: MyApp(),
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