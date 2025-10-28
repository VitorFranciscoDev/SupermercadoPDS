import 'package:sqflite/sqflite.dart';
import 'package:supermercado/model/database/database_provider.dart';
import 'package:supermercado/model/enum_tipo_usuario.dart';
import 'package:supermercado/model/usuario.dart';

// classe abstrata com os contratos
abstract class IUsuarioUseCase {
  String? validarNome(String nome);

  String? validarCPF(String cpf);

  Future<String?> cadastrarUsuario(String nome, String cpf, TipoUsuario tipo);

  Future<Usuario?> fazerLogin(String nome, String cpf);
}

class UsuarioRepository {
  // provider do Database
  final DatabaseProvider dbProvider = DatabaseProvider();

  // função para buscar o usuário por CPF(Verificar se o usuário já existe)
  Future<Usuario?> procurarUsuarioPorCPF(String cpf) async {
    Database db = await dbProvider.database;

    // busca o usuário por CPF
    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    // retorna o usuário existente
    if(result.isNotEmpty) return Usuario.fromMap(result.first);

    return null;
  }

  // função para registrar o usuário no Database
  Future<int> registrarUsuario(Usuario usuario) async {
    Database db = await dbProvider.database;

    // transforma o usuário em Map
    Map<String, dynamic> usuarioMap = usuario.toMap();

    // registra no Database
    return await db.insert('usuarios', usuarioMap);
  }

  // função para verificar se o usuário existe e fazer o login
  Future<Usuario?> verificarLogin(String nome, String cpf) async {
    Database db = await dbProvider.database;

    // busca o usuário por CPF
    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    // se houver usuário com esse CPF, analisa se o nome também está correto
    if(result.isNotEmpty) {
      Usuario usuario = Usuario.fromMap(result.first);
      if(usuario.nome == nome) return usuario; // retorna o usuário caso o nome esteja correto
    }

    return null;
  }
}

class UsuarioUseCase implements IUsuarioUseCase {
  UsuarioUseCase({ required this.usuarioRepo });

  // repositório do usuário
  final UsuarioRepository usuarioRepo;

  // função para validar o nome
  @override
  String? validarNome(String nome) => nome.isEmpty ? "Nome não pode estar vazio" : null;

  // função para validar o CPF
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

  // função para cadastrar o usuário
  @override
  Future<String?> cadastrarUsuario(String nome, String cpf, TipoUsuario tipo) async {
    // verifica se o usuário já não existe
    final resultado = await usuarioRepo.procurarUsuarioPorCPF(cpf);

    // caso não seja nulo, retorna que já há um usuário com esse CPF
    if(resultado!=null) {
      return "CPF existente";
    } else {
      try {
        Usuario usuario = Usuario(nome: nome, cpf: cpf, tipo: tipo);

        // registra o usuário e result recebe o id desse novo usuário registrado
        int result = await usuarioRepo.registrarUsuario(usuario);
        
        // se o id for maior que 0, retorna null(sucesso)
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

  // função para fazer Login
  @override
  Future<Usuario?> fazerLogin(String nome, String cpf) async {
    final result = await usuarioRepo.verificarLogin(nome, cpf);

    if(result!=null) {
      return result;
    }

    return null;
  }
}