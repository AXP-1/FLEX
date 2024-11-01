import 'package:flex/routes/route_names.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/utils/storage_keys.dart';
import 'package:flex/utils/storage_service.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  var registerLoading = false.obs;
  var loginLoading = false.obs;


  // تسجيل مستخدم جديد
  Future<void> register(String name, String email, String password) async {
    try {
      registerLoading.value = true;
      final AuthResponse data = await SupabaseService.SupabaseClient.auth
          .signUp(email: email, password: password, data: {"name": name});

      registerLoading.value = false;

      if (data.user != null) {
        StorageService.session
            .write(StorageKeys.userSession, data.session!.toJson());
        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (error) {
      registerLoading.value = false;
      showSnackBar("Error", error.message);
    }
  }

  //* تسجيل دخول مستخدم
  Future<void> login(String email, String password) async {
    try {
      loginLoading.value = true;
      final AuthResponse response = await SupabaseService.SupabaseClient.auth
          .signInWithPassword(email: email, password: password);

      loginLoading.value = false;
      if (response.user != null) {
        StorageService.session
            .write(StorageKeys.userSession, response.session!.toJson());
        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (error) {
      loginLoading.value = false;
      showSnackBar("Error", error.message);
    }
  }
}
