import 'package:flex/controllers/settings_controller.dart';
import 'package:flex/controllers/theme_controller.dart'; // استيراد ThemeController
import 'package:flex/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final SettingsController controller = Get.put(SettingsController());
  final ThemeController themeController = Get.find(); // جلب ThemeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                confirmDialog(
                    "Are you sure?", "This action will log you out from the app.", controller.logout);
              },
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              trailing: const Icon(Icons.arrow_forward),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Change Appearance"),
              trailing: Obx(
                () => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) {
                    themeController.toggleTheme(); // تبديل الثيم عند تغيير القيمة
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About the Project"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("About the Project"),
                      content: const Text(
                        "مشروع تخرج طلاب علوم الحاسوب دفعة 2018\n"
                        "مشروع بإسم FLEX منصة إعلامية للجامعة\n"
                        "صنع بفخر بواسطة:\n"
                        "عبد الله نور الدين فوزي\n"
                        "قنوان محمد هاشم\n"
                        "عز الدين محمد آدم",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
