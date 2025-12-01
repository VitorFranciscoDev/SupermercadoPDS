import 'package:supermercado/models/database_helper.dart';
import '../models/usuario.dart';

class UsuarioController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> cadastrarUsuario({
    required String nome,
    required String cpf,
    required bool isAdministrador,
  }) async {
    try {
      // Validações
      if (nome.trim().isEmpty) {
        throw Exception('Nome não pode estar vazio');
      }

      if (cpf.trim().isEmpty || !_validarCpf(cpf)) {
        throw Exception('CPF inválido');
      }

      // Verifica se CPF já existe
      final usuarioExistente = await _dbHelper.buscarUsuarioPorCpf(cpf);
      if (usuarioExistente != null) {
        throw Exception('CPF já cadastrado');
      }

      final usuario = Usuario(
        nome: nome,
        cpf: cpf,
        isAdministrador: isAdministrador,
      );

      await _dbHelper.inserirUsuario(usuario);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Usuario?> fazerLogin(String nome, String cpf) async {
    try {
      if (nome.trim().isEmpty || cpf.trim().isEmpty) {
        throw Exception('Nome e CPF são obrigatórios');
      }

      final usuario = await _dbHelper.buscarUsuarioPorCpf(cpf);
      
      if (usuario == null) {
        throw Exception('Usuário não encontrado');
      }

      if (usuario.nome != nome) {
        throw Exception('Nome não corresponde ao CPF informado');
      }

      return usuario;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Usuario>> listarTodosUsuarios() async {
    return await _dbHelper.listarUsuarios();
  }

  bool _validarCpf(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Valida se tem 11 dígitos
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    return true;
  }

  String formatarCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    }
    return cpf;
  }
}