import 'package:flutter/material.dart';
import 'package:supermercado/entities/user.dart';

class LoginState with ChangeNotifier {
  User? user;

  void registrarUsuario(User newUser) {
    user = User(nome: newUser.nome, cpf: newUser.cpf, isAdmin: newUser.isAdmin);
  }
}