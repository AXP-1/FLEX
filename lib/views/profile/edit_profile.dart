import 'package:flex/controllers/profile_controller.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  final ProfileController controller = Get.find<ProfileController>();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    if (supabaseService.currentUser.value?.userMetadata?["description"] !=
        null) {
      textEditingController.text =
          supabaseService.currentUser.value?.userMetadata?["description"];
    }

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                controller.updateProfile(supabaseService.currentUser.value!.id,
                    textEditingController.text);
              },
              child: controller.loading.value
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(),
                    )
                  : Text("Done")))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(() => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleImage(
                      radius: 80,
                      file: controller.image.value,
                      url: supabaseService
                          .currentUser.value?.userMetadata?["image"],
                    ),
                    IconButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      icon: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white60,
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Enter your Description",
                  label: Text("Description")),
            )
          ],
        ),
      ),
    );
  }
}
