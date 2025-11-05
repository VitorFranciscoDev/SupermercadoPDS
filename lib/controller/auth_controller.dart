import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermercado/model/user.dart';
import 'package:supermercado/model/userDAO.dart';

class AuthController with ChangeNotifier {
  AuthController({ required this.userDAO }) {
    loadUser();
  }

  final UserDAO userDAO;

  User? _user;
  User? get user => _user;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorName;
  String? _errorCPF;

  String? get errorName => _errorName;
  String? get errorCPF => _errorCPF;

  bool validateFields(String name, String cpf) {
    if(name.isEmpty) {
      _errorName = "Nome não pode ser vazio";
    } else {
      _errorName = null;
    }

    if(cpf.isEmpty) {
      _errorCPF = "CPF não pode ser vazio";
    } else if(cpf.length != 11) {
      _errorCPF = "CPF tem que conter 11 dígitos";
    } else {
      _errorCPF = null;
    }
    
    notifyListeners();
    
    return _errorName == null && _errorCPF == null;
  }

  void clearErrors() {
    _errorName = null;
    _errorCPF = null;

    notifyListeners();
  }

  Future<void> loadUser() async {
    _isInitialized = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');

      if (userData != null) {
        final map = jsonDecode(userData);
        _user = User.fromMap(map);
        notifyListeners();
      }
    } catch(e) {
      throw Exception("Error in Load User: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<String?> addUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Verifies if User with same Email already exists
      final existingUser = await userDAO.getUserByCPF(user.cpf);

      if(existingUser != null) {
        return "Já existe alguém com este CPF.";
      }

      // Receives the ID of new User
      final result = await userDAO.addUser(user);

      if(result > 0) return null;
      return "Erro no Cadastro.";
    } catch (e) {
      return 'Erro Inesperado.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deleteUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Receives the number of rows affected
      final result = await userDAO.deleteUser(user?.id);

      if(result > 0) return null;
      return "Erro em Excluir Usuário.";
    } catch (e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateUser(User? user) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Receives the number of rows affected
      final result = await userDAO.updateUser(user!);
      
      if(result > 0) {
        _user = user;
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(user.toMap()));

        return null;
      }

      return "Erro em Editar Usuário.";
    } catch (e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> doLogin(String name, String cpf) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Receives the User
      final user = await userDAO.doLogin(name, cpf);

      if(user!=null) {
        _user = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(user.toMap()));

        notifyListeners();

        return null;
      }
      
      return "Nome ou CPF incorretos.";
    } catch (e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
    } catch(e) {
      throw Exception("Error in Log Out: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}