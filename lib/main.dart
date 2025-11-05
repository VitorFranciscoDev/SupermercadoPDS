import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/auth_controller.dart';
import 'package:supermercado/model/userDAO.dart';
import 'package:supermercado/view/app.dart';

void main() {
  final userDAO = UserDAO();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(userDAO: userDAO)),
      ],
      child: const MyApp(),
    ),
  );
}