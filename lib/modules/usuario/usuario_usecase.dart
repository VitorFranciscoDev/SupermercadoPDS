import 'package:supermercado/entities/enum_tipo_usuario.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/modules/usuario/usuario_repository.dart';
import 'package:supermercado/modules/usuario/usuario_spec.dart';

class UsuarioUseCase implements IUsuarioUseCase {
  UsuarioUseCase({ required this.usuarioRepo });

  //Repositório do usuário
  final UsuarioRepository usuarioRepo;

  //Função para validar o nome
  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  //Função para validar o CPF
  @override
  String? validarCPF(String cpf) {
    if(cpf.isEmpty) {
      return "CPF não pode estar vazio";
    } else if(cpf.length!=11) {
      return "CPF deve ter 11 números";
    } else {
      return null;
    }
  }

  //Função para cadastrar o usuário
  @override
  Future<String?> cadastrarUsuario(String nome, String cpf, TipoUsuario tipo) async {
    //Verifica se o usuário já não existe
    final resultado = await usuarioRepo.procurarUsuarioPorCPF(cpf);

    //Caso não seja nulo, retorna que já há um usuário com esse CPF
    if(resultado!=null) {
      return "CPF existente";
    } else {
      try {
        Usuario usuario = Usuario(nome: nome, cpf: cpf, tipo: tipo);

        //Registra o usuário e result recebe o id desse novo usuário registrado
        int result = await usuarioRepo.registrarUsuario(usuario);
        
        //Se o id for maior que 0, retorna null(sucesso)
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

  @override
  Future<Usuario?> fazerLogin(String nome, String cpf) async {
    final result = await usuarioRepo.verificarLogin(nome, cpf);

    if(result!=null) {
      return result;
    }

    return null;
  }
}