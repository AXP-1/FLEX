import 'package:flex/routes/route_names.dart';
import 'package:flex/services/storage_service.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/storage_keys.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  void logout() async{
    // انهاء الجلسة من الجهاز 
    StorageService.session.remove(StorageKeys.userSession);
    await SupabaseService.SupabaseClient.auth.signOut();
    Get.offAllNamed(RouteNames.login);
  }
}