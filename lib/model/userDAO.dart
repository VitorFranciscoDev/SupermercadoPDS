import 'package:supermercado/database/database.dart';
import 'package:supermercado/model/user.dart';

class UserDAO {
  final database = SupermercadoDatabase();

  Future<int> addUser(User user) async {
    try {
      final db = await database.database;

      // Returns the index of the User
      return await db.insert('users', user.toMap());
    } catch (e) {
      throw Exception("Error in Add User: $e");
    }
  } 

  Future<int> deleteUser(int? id) async {
    try {
      final db = await database.database;

      // Returns the number of rows affected
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch(e) {
      throw Exception("Error in Delete User: $e");
    }
  }

  Future<int> updateUser(User user) async {
    try {
      final db = await database.database;

      // Returns the number of rows affected
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      throw Exception("Error in Update User: $e");
    }
  }

  Future<User?> doLogin(String name, String cpf) async {
    try {
      final db = await database.database;

      // Receives User
      final result = await db.query(
        'users',
        where: 'name = ? AND cpf = ?',
        whereArgs: [name, cpf],
      );

      if(result.isNotEmpty) {
        return User.fromMap(result.first);
      }

      return null;
    } catch(e) {
      throw Exception("Error in Do Login: $e");
    }
  }

  Future<User?> getUserByCPF(String cpf) async {
    try {
      final db = await database.database;

      // Receives User
      final existingUser = await db.query(
        'users',
        where: 'cpf = ?',
        whereArgs: [cpf],
      );

      if(existingUser.isNotEmpty) {
        return User.fromMap(existingUser.first);
      }

      return null;
    } catch(e) {
      throw Exception("Error in Get User By CPF: $e");
    }
  }

}