import 'dart:io';
import 'package:flex/utils/env.dart';
import 'package:flex/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

void showSnackBar(String title, String message) {
  Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      backgroundColor: const Color(0xff252526),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      snackStyle: SnackStyle.GROUNDED,
      margin: const EdgeInsets.all(0.0));
}

// اختيار الصورة من الجهاز
Future<File?> pickImageFromGallery() async {
  const uuid = Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
  if (file == null) return null;
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v6()}.jpg";
  File image = await compressImage(File(file.path), targetPath);

  return image;
}

// ضغط الصورة
Future<File> compressImage(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
      file.path, targetPath,
      quality: 70);
  return File(result!.path);
}

// استلام الصورة من قاعدة البيانات
String getS3Url(String path) {
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}

// اشعار تأكيد تسجيل الخروج
void confirmDialog(String title, String text, VoidCallback callback) {
  Get.dialog(ConfirmDialog(
    title: title,
    text: text,
    callback: callback,
  ));
}

// ضبط الوقت والتاريخ
String formatDateFromNow(String date) {
  // تعديل الوقت من التوقيت العالمي الموحد الى التوقيت الحالي في المنطقة
  DateTime utcDateTime = DateTime.parse(date.split("+")[0].trim());

  // تغيير الوقت الموحد الى توقيت السودان
  DateTime sudanDateTime = utcDateTime.add(const Duration(hours: 3));

  //  ضبط التاريخ 
  return Jiffy.parseFromDateTime(sudanDateTime).fromNow();
}
