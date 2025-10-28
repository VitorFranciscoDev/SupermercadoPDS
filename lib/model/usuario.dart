import 'package:supermercado/model/enum_tipo_usuario.dart';

class Usuario {
  // variáveis
  final int? id;
  final String nome;
  final String cpf;
  final TipoUsuario tipo;

  // construtor
  Usuario({ this.id, required this.nome, required this.cpf, required this.tipo });

  // transforma em Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'tipoUsuario': tipo.index,
    };
  }

  // desconstrói o Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'].toString(),
      tipo: TipoUsuario.values[map['tipoUsuario']],
    );
  }
}