import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent extends StatefulWidget {
  const TextFieldComponent({ super.key, required this.controller, this.hint, this.erro, this.tipo, this.formatter });
  final TextEditingController controller; //Controller que será passado ao botão
  final String? hint; //Hint text que será passado ao botão
  final String? erro; //Variável de erro que será passada ao botão
  final TextInputType? tipo; //Tipo de teclado que irá aparecer
  final TextInputFormatter? formatter; //Tipo de dígito que o TextField recebe(CPF só recebe números, por exemplo)

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.tipo,
      decoration: InputDecoration(
        hintText: widget.hint,
        errorText: widget.erro,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}