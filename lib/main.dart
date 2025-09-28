import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/infrastructure/presentation/login/login_screen.dart';
import 'package:supermercado/infrastructure/presentation/login/login_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginState()),
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