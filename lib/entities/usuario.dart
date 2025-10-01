import 'package:supermercado/entities/enum_tipo_usuario.dart';

class Usuario {
  //Variáveis
  final int? id;
  final String nome;
  final String cpf;
  final TipoUsuario tipo;

  //Construtor
  Usuario({ this.id, required this.nome, required this.cpf, required this.tipo });

  //Transforma em Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'tipoUsuario': tipo.index,
    };
  }

  //Desconstrói o Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      tipo: TipoUsuario.values[map['tipoUsuario']],
    );
  }
}