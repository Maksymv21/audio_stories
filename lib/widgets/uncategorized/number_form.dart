import 'package:flutter/material.dart';

class NumberForm extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const NumberForm({
    Key? key,
    required this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 6.0,
      borderRadius: BorderRadius.circular(45.0),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20.0,
          letterSpacing: 1.0,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          constraints: const BoxConstraints(
            maxWidth: 309.0,
            maxHeight: 60.0,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(45.0),
            ),
          ),
        ),
      ),
    );
  }
}
