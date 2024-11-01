import 'package:flutter/material.dart';

ButtonStyle customOutlineStyle(BuildContext context) {
  return OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    side: BorderSide(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white // اللون في الوضع الليلي
          : Colors.black, // اللون في الوضع النهاري
    ),
    foregroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // لون النص في الوضع الليلي
        : Colors.black, // لون النص في الوضع النهاري
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850] // خلفية خفيفة في الوضع الليلي
        : Colors.white, // خلفية خفيفة في الوضع النهاري
  );
}
