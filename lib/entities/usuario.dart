import 'package:supermercado/entities/enum_tipo_usuario.dart';

class Usuario {
  final int? id;
  final String nome;
  final String cpf;
  final TipoUsuario tipo;

  Usuario({ this.id, required this.nome, required this.cpf, required this.tipo });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'tipoUsuario': tipo.index,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      tipo: TipoUsuario.values[map['tipoUsuario']],
    );
  }
}