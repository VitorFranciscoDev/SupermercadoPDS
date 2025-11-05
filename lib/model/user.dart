class User {
  final int? id;
  final String name;
  final String cpf;
  final bool isAdmin;

  User({ this.id, required this.name, required this.cpf, required this.isAdmin });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'], 
      cpf: map['cpf'], 
      isAdmin: map['isAdmin'],
    );
  }
}