import 'package:flex/routes/route.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/theme/theme.dart';
import 'package:flex/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init(); 
  Get.put(SupabaseService());
  Get.put(ThemeController()); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FLEX',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.theme, 
        getPages: Routes.pages,
        initialRoute: StorageService.userSession != null
            ? RouteNames.home
            : RouteNames.login,
        defaultTransition: Transition.noTransition,
      ),
    );
  }
}
