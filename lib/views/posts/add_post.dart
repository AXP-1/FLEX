import 'package:flex/controllers/post_controller.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/widgets/add_post_appbar.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/post_image_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddPostAppbar(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => CircleImage(
                      url: supabaseService
                          .currentUser.value!.userMetadata?["image"],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: context.width * 0.80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            supabaseService
                                .currentUser.value!.userMetadata?["name"],
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          controller: controller.textEditingController,
                          onChanged: (value) =>
                              controller.content.value = value,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 10,
                          minLines: 1,
                          maxLength: 1000,
                          decoration: const InputDecoration(
                            hintText: "Type your post",
                            border: InputBorder.none,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.pickImage(),
                          child: const Icon(Icons.attach_file),
                        ),

                        // لإظهار صورة المستخدم
                        Obx(
                          () => Column(
                            children: [
                              if (controller.image.value != null)
                                PostImagePreview(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
