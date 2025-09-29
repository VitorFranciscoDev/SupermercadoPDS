import 'package:supermercado/entities/enum_tipo.dart';

class User {
  final String nome;
  final int cpf;
  final Tipo tipo;

  User({ required this.nome, required this.cpf, required this.tipo });
}