import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';

class UsuarioUseCase {
  UsuarioUseCase({ required this.usuarioRepo });

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

  Future<String?> cadastrarUsuario(String nome, String cpf, TipoUsuario tipo) async {
    final resultado = await usuarioRepo.procurarUsuarioPorCPF(cpf);

    if(resultado!=null) {
      return "Usuário existente";
    } else {
      try {
        Usuario usuario = Usuario(nome: nome, cpf: cpf, tipo: tipo);
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
}