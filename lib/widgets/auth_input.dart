import 'package:flutter/material.dart';
import 'package:flex/utils/type_def.dart';

class AuthInput extends StatelessWidget {
  final String label, hintText;
  final bool isPasswordField;
  final TextEditingController controller;
  final ValidatorCallback validatorCallback;
  const AuthInput(
      {required this.label,
      this.isPasswordField = false,
      required this.hintText,
      required this.controller,
      required this.validatorCallback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validatorCallback,
      controller: controller,
      obscureText: isPasswordField,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          label: Text(label),
          hintText: hintText),
    );
  }
}
