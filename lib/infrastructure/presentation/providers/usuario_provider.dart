import 'package:flutter/material.dart';
import 'package:supermercado/entities/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? usuario;

  void registrarUsuario(Usuario novoUsuario) {
    usuario = Usuario(nome: novoUsuario.nome, cpf: novoUsuario.cpf, tipo: novoUsuario.tipo);
    notifyListeners();
  }
}