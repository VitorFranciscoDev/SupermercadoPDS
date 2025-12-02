import '../models/usuario.dart';
import 'database_helper.dart';

class UsuarioDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Inserir novo usuário
  Future<int> inserir(Usuario usuario) async {
    final db = await _dbHelper.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  // Buscar usuário por CPF
  Future<Usuario?> buscarPorCpf(String cpf) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [cpf],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  // Buscar usuário por ID
  Future<Usuario?> buscarPorId(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }

  // Listar todos os usuários
  Future<List<Usuario>> listarTodos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');
    return List.generate(maps.length, (i) => Usuario.fromMap(maps[i]));
  }

  // Atualizar usuário
  Future<int> atualizar(Usuario usuario) async {
    final db = await _dbHelper.database;
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // Deletar usuário
  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Verificar se CPF já existe
  Future<bool> cpfExiste(String cpf) async {
    final usuario = await buscarPorCpf(cpf);
    return usuario != null;
  }
}