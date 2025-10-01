import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/usuario.dart';

abstract class IUsuarioUseCase {
  String? validarNome(String nome);

  String? validarCPF(String cpf);

  Future<String?> cadastrarUsuario(String nome, String cpf, TipoUsuario tipo);

  Future<Usuario?> fazerLogin(String nome, String cpf);
}