import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';

class CadastroUsuarioUseCase {
  CadastroUsuarioUseCase({ required this.usuarioRepo });

  final UsuarioRepository usuarioRepo;

  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  String? validarCPF(String cpf) {
    if(cpf.isEmpty) {
      return "CPF não pode estar vazio";
    } else if(cpf.length!=11) {
      return "CPF deve ter 11 números";
    } else {
      return null;
    }
  }

  Future<String?> registrarUsuario(String nome, String cpf, TipoUsuario tipo) async {
    final erroNome = validarNome(nome);
    if(erroNome!=null) return erroNome;

    final erroCPF = validarCPF(cpf);
    if(erroCPF!=null) return erroCPF;

    try {
      Usuario usuario = Usuario(nome: nome, cpf: int.parse(cpf), tipo: tipo);
      int result = await usuarioRepo.registrarUsuario(usuario);
      
      if(result>0) {
        return null;
      } else {
        return "Erro no cadastro";
      }
    } catch(e) {
      return "Erro no cadastro";
    }
  }
}