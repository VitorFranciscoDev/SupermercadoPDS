class Usuario {
  int? _id;
  String _nome;
  String _cpf;
  bool _isAdministrador;

  Usuario({
    int? id,
    required String nome,
    required String cpf,
    required bool isAdministrador,
  })  : _id = id,
        _nome = nome,
        _cpf = cpf,
        _isAdministrador = isAdministrador;

  // Getters
  int? get id => _id;
  String get nome => _nome;
  String get cpf => _cpf;
  bool get isAdministrador => _isAdministrador;

  // Setters
  set id(int? value) => _id = value;
  set nome(String value) => _nome = value;
  set cpf(String value) => _cpf = value;
  set isAdministrador(bool value) => _isAdministrador = value;

  // Conversão para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'cpf': _cpf,
      'isAdministrador': _isAdministrador ? 1 : 0,
    };
  }

  // Criação a partir de Map (para ler do banco)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      isAdministrador: map['isAdministrador'] == 1,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $_id, nome: $_nome, cpf: $_cpf, isAdministrador: $_isAdministrador}';
  }
}