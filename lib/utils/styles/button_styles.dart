import 'package:flutter/material.dart';

ButtonStyle customOutlineStyle(BuildContext context) {
  return ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    side: MaterialStateProperty.all(
      BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
      ),
    ),
    backgroundColor: MaterialStateProperty.all(
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    ),
    foregroundColor: MaterialStateProperty.all(
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
    ),
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    ),
    visualDensity: VisualDensity.compact,
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

