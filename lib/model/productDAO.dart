import 'package:supermercado/database/database.dart';
import 'package:supermercado/model/product.dart';

class ProductDAO {
  final database = SupermercadoDatabase();

  Future<int> addProduct(Product product) async {
    try {
      final db = await database.database;

      // Returns the index of the Product
      return await db.insert('products', product.toMap());
    } catch (e) {
      throw Exception("Error in Add Product: $e");
    }
  } 

  Future<int> deleteProduct(int? id) async {
    try {
      final db = await database.database;

      // Returns the number of rows affected
      return await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch(e) {
      throw Exception("Error in Delete Product: $e");
    }
  }

  Future<int> updateProduct(Product product) async {
    try {
      final db = await database.database;

      // Returns the number of rows affected
      return await db.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw Exception("Error in Update Product: $e");
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final db = await database.database;

      // All Products
      final result = await db.query('products');
      return result.map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      throw Exception("Error in Get All Products: $e");
    }
  }
}