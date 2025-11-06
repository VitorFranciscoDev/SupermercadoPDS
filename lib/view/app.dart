import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/auth_controller.dart';
import 'package:supermercado/view/bottom_navigator.dart';
import 'package:supermercado/view/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthController>();

    if(!provider.isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF2E7D32).withOpacity(0.3),
                  ),
                  child: Icon(Icons.shopping_cart, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: provider.user != null ? BottomNavigator() : LoginScreen(),
    );
  }
}