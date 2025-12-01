class Produto {
  int? _id;
  String _nome;
  String _descricao;
  double _preco;
  int _quantidadeEstoque;

  Produto({
    int? id,
    required String nome,
    required String descricao,
    required double preco,
    required int quantidadeEstoque,
  })  : _id = id,
        _nome = nome,
        _descricao = descricao,
        _preco = preco,
        _quantidadeEstoque = quantidadeEstoque;

  // Getters
  int? get id => _id;
  String get nome => _nome;
  String get descricao => _descricao;
  double get preco => _preco;
  int get quantidadeEstoque => _quantidadeEstoque;

  // Setters
  set id(int? value) => _id = value;
  set nome(String value) => _nome = value;
  set descricao(String value) => _descricao = value;
  set preco(double value) => _preco = value;
  set quantidadeEstoque(int value) => _quantidadeEstoque = value;

  // Conversão para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'descricao': _descricao,
      'preco': _preco,
      'quantidadeEstoque': _quantidadeEstoque,
    };
  }

  // Criação a partir de Map (para ler do banco)
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      preco: map['preco'],
      quantidadeEstoque: map['quantidadeEstoque'],
    );
  }

  @override
  String toString() {
    return 'Produto{id: $_id, nome: $_nome, preco: $_preco, estoque: $_quantidadeEstoque}';
  }
}