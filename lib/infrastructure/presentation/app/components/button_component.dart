import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  const ButtonComponent({ super.key, required this.metodo, required this.mensagem });
  final void Function() metodo; //Função que irá ser passada ao botão
  final String mensagem; //Mensagem do botão

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
          side: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () => widget.metodo(),
      child: Text(widget.mensagem, 
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}