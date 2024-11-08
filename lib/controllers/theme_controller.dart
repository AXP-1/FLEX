import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage storage = GetStorage();
  RxBool isDarkMode = true.obs; 

  ThemeController() {
    isDarkMode.value = storage.read('isDarkMode') ?? true;
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storage.write('isDarkMode', isDarkMode.value); 
  }
}
