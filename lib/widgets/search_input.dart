import 'package:flex/utils/type_def.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final InputCallback callback;

  const SearchInput(
      {required this.controller, required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم الثيم للحصول على الألوان الصحيحة
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      onChanged: callback,
      style: TextStyle(color: theme.colorScheme.onSurface), // لون النص يعتمد على الثيم
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurface.withOpacity(0.6), // لون الأيقونة يعتمد على الثيم
        ),
        filled: true,
        fillColor: theme.colorScheme.surface, // لون الخلفية يعتمد على الثيم
        hintText: "Search user..",
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)), // لون النص التلميحي يعتمد على الثيم
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.2), // لون الحد يعتمد على الثيم
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.4), // لون الحد أثناء التركيز يعتمد على الثيم
          ),
        ),
      ),
    );
  }
}
