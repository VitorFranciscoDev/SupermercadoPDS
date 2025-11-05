import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/auth_controller.dart';
import 'package:supermercado/controller/bottom_navigator_controller.dart';
import 'package:supermercado/controller/product_controller.dart';
import 'package:supermercado/model/productDAO.dart';
import 'package:supermercado/model/userDAO.dart';
import 'package:supermercado/view/app.dart';

void main() {
  final userDAO = UserDAO();

  final productDAO = ProductDAO();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigatorController()),
        ChangeNotifierProvider(create: (_) => AuthController(userDAO: userDAO)),
        ChangeNotifierProvider(create: (_) => ProductController(productDAO: productDAO)),
      ],
      child: const MyApp(),
    ),
  );
}