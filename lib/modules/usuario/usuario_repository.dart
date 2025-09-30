import 'package:sqflite/sqflite.dart';
import 'package:supermercado/entities/usuario.dart';
import 'package:supermercado/infrastructure/database/database_provider.dart';

class UsuarioRepository {
  final DatabaseProvider dbProvider = DatabaseProvider();

  Future<int> registrarUsuario(Usuario usuario) async {
    Database db = await dbProvider.database;
    Map<String, dynamic> usuarioMap = usuario.toMap();
    return await db.insert('usuarios', usuarioMap);
  }

  Future<Usuario?> verificarLogin(String nome, int cpf) async {
    Database db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    if(result.isNotEmpty) {
      Usuario usuario = Usuario.fromMap(result.first);

      if(usuario.nome == nome) {
        return usuario;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}