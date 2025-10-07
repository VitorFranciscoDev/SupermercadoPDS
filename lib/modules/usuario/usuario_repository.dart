import 'package:sqflite/sqflite.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';

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