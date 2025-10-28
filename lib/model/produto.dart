class Produto {
  // variáveis
  final int? id;
  final String nome;
  final double preco;
  final int quantidade;

  // construtor
  Produto({ this.id, required this.nome, required this.preco, required this.quantidade });

  // transforma em Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  // desconstrói o Map
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'], 
      preco: map['preco'], 
      quantidade: map['quantidade'],
    );
  }
}