import 'package:flex/controllers/post_controller.dart';
import 'package:flex/widgets/loading.dart';
import 'package:flex/widgets/post_card.dart';
import 'package:flex/widgets/reply_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPost extends StatefulWidget {
  const ShowPost({super.key});

  @override
  State<ShowPost> createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  final int postId = Get.arguments;
  final PostController controller = Get.put(PostController());
  

  @override
  void initState() {
    controller.show(postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: Obx(() => controller.showPostLoading.value
          ? const Loading()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  PostCard(post: controller.post.value),
                  const SizedBox(height: 20),

                  // تحميل التعليقات الخاصة بالمنشور
                  if (controller.showReplyLoading.value)
                    const Loading()
                  else if (controller.replies.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.replies.length,
                      itemBuilder: (context, index) =>
                          ReplyCard(reply: controller.replies[index]),
                    )
                ],
              ),
            )),
    );
  }
}
