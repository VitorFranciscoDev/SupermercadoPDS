import 'package:flutter/material.dart';
import 'package:supermercado/models/usuarioDAO.dart';
import '../models/usuario.dart';

class UsuarioController extends ChangeNotifier {
  final UsuarioDAO _usuarioDAO = UsuarioDAO();
  
  Usuario? _usuarioLogado;
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _mensagemErro;

  // Getters
  Usuario? get usuarioLogado => _usuarioLogado;
  List<Usuario> get usuarios => _usuarios;
  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;
  bool get isLogado => _usuarioLogado != null;
  bool get isAdministrador => _usuarioLogado?.isAdministrador ?? false;

  // Limpar mensagem de erro
  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }

  // Cadastrar novo usuário
  Future<bool> cadastrarUsuario({
    required String nome,
    required String cpf,
    required bool isAdministrador,
  }) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome não pode estar vazio');
      }

      if (cpf.trim().isEmpty || !_validarCpf(cpf)) {
        throw Exception('CPF inválido');
      }

      // Verifica se CPF já existe
      final cpfExiste = await _usuarioDAO.cpfExiste(cpf);
      if (cpfExiste) {
        throw Exception('CPF já cadastrado');
      }

      final usuario = Usuario(
        nome: nome,
        cpf: cpf,
        isAdministrador: isAdministrador,
      );

      await _usuarioDAO.inserir(usuario);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fazer login
  Future<bool> fazerLogin(String nome, String cpf) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      if (nome.trim().isEmpty || cpf.trim().isEmpty) {
        throw Exception('Nome e CPF são obrigatórios');
      }

      final usuario = await _usuarioDAO.buscarPorCpf(cpf);
      
      if (usuario == null) {
        throw Exception('Usuário não encontrado');
      }

      if (usuario.nome != nome) {
        throw Exception('Nome não corresponde ao CPF informado');
      }

      _usuarioLogado = usuario;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _mensagemErro = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fazer logout
  void fazerLogout() {
    _usuarioLogado = null;
    notifyListeners();
  }

  // Listar todos os usuários
  Future<void> carregarUsuarios() async {
    _isLoading = true;
    notifyListeners();

    try {
      _usuarios = await _usuarioDAO.listarTodos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _mensagemErro = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Validar CPF
  bool _validarCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    return true;
  }

  // Formatar CPF
  String formatarCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    }
    return cpf;
  }
}