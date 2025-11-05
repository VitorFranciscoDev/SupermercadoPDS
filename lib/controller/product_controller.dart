import 'package:flutter/material.dart';
import 'package:supermercado/model/product.dart';
import 'package:supermercado/model/productDAO.dart';

class ProductController extends ChangeNotifier {
  ProductController({ required this.productDAO }) {
    getAllProducts();
  }

  final ProductDAO productDAO;

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorName;
  String? _errorPrice;
  String? _errorQuantity;

  String? get errorName => _errorName;
  String? get errorPrice => _errorPrice;
  String? get errorQuantity => _errorQuantity;

  bool validateProduct(String name, String price, String quantity) {
    if(name.isEmpty) {
      _errorName = "Nome não pode estar vazio";
    } else {
      _errorName = null;
    }

    if(price.isEmpty) {
      _errorPrice = "Preço não pode ser vazio";
    } else if(!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(price)) {
      _errorPrice = "Preço tem que conter apenas números";
    } else {
      _errorPrice = null;
    }

    if(quantity.isEmpty) {
      _errorQuantity = "Quantidade não pode ser vazia";
    } else if(!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(quantity)) {
      _errorQuantity = "Quantidade tem que conter apenas números";
    } else {
      _errorQuantity = null;
    }

    notifyListeners();

    return _errorName == null && _errorPrice == null && _errorQuantity == null;
  }

  Future<String?> addProduct(Product product, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Receives index of new User
      final result = await productDAO.addProduct(product);

      if(result > 0) return null;
      return "Erro ao Adicionar Produto.";
    } catch(e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deleteProduct(int? id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await productDAO.deleteProduct(id!);

      if(result > 0) return null;
      return "Erro ao Remover Produto";
    } catch(e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateProduto(Product product, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await productDAO.updateProduct(product);

      if(result > 0) return null;
      return "Erro ao Editar Produto.";
    } catch(e) {
      return "Erro Inesperado.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allProducts = await productDAO.getAllProducts();

      if(allProducts != []) {
        _products = allProducts;
        notifyListeners();
      }
    } catch(e) {
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}