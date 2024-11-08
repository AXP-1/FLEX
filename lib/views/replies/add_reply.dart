import 'package:flex/controllers/reply_controller.dart';
import 'package:flex/models/post_model.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/post_card_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddReply extends StatelessWidget {
  AddReply({super.key});
  final PostModel post = Get.arguments;
  final ReplyController controller = Get.put(ReplyController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.close)),
        title: const Text("Reply Section"),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () {
                if (controller.reply.isNotEmpty) {
                  controller.addReply(supabaseService.currentUser.value!.id,
                      post.id!, post.userId!);
                }
              },
              child: controller.loading.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "Reply Now",
                      style: TextStyle(
                          fontWeight: controller.reply.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.width * 0.12,
                  child: CircleImage(
                    url: post.user?.metadata?.image,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: context.width * 0.80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user!.metadata!.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(post.content!),
                      const SizedBox(height: 10),
                      if (post.image != null) PostCardImage(url: post.image!),

                      // قسم التعليق
                      TextField(
                          autofocus: true,
                          controller: controller.replyController,
                          onChanged: (value) => controller.reply.value = value,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 10,
                          minLines: 1,
                          maxLength: 1000,
                          decoration: const InputDecoration(
                            hintText: "Type your Reply here:",
                            border: InputBorder.none,
                          ))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
