import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  const TextFieldComponent({ super.key, required this.controller, this.hint, this.erro });
  final TextEditingController controller;
  final String? hint;
  final String? erro;

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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