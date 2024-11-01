import 'package:flex/controllers/post_controller.dart';
import 'package:flex/models/post_model.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCardBottomBar extends StatefulWidget {
  final PostModel post;
  const PostCardBottomBar({required this.post, super.key});

  @override
  State<PostCardBottomBar> createState() => _PostCardBottomBarState();
}

class _PostCardBottomBarState extends State<PostCardBottomBar> {
  bool isLiked = false;
  int likeCount = 0;
  final PostController controller = Get.find<PostController>();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likeCount ?? 0;

    // التحقق مما إذا كان المستخدم الحالي قد أعجب بالمنشور
    checkIfLiked();
  }

  // التحقق مما إذا كان المستخدم الحالي قد أعجب بالمنشور
  void checkIfLiked() async {
  final currentUserId = supabaseService.currentUser.value?.id;
  final postId = widget.post.id;

  // التحقق من أن معرف المستخدم ومعرف المنشور ليسا فارغين
  if (currentUserId == null || postId == null) return;

  final response = await SupabaseService.SupabaseClient
      .from('likes')
      .select()
      .eq('user_id', currentUserId)
      .eq('post_id', postId)
      .maybeSingle();

  if (response != null) {
    setState(() {
      isLiked = true;
    });
  }
}


  void toggleLike() async {
    final currentUserId = supabaseService.currentUser.value?.id;
    if (currentUserId == null) return;

    if (isLiked) {
      // إذا كان المستخدم قد أعجب بالفعل، نقوم بإلغاء الإعجاب
      await controller.dislikePost(widget.post.id!, currentUserId);
      setState(() {
        isLiked = false;
        likeCount = likeCount > 0 ? likeCount - 1 : 0;
      });
    } else {
      // إذا لم يعجب بعد، نقوم بالإعجاب
      await controller.likePost(widget.post.id!, currentUserId);
      setState(() {
        isLiked = true;
        likeCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // زر الإعجاب مع عدد الإعجابات
        Row(
          children: [
            IconButton(
              onPressed: toggleLike,
              icon: Icon(
                Icons.keyboard_double_arrow_up_outlined,
                color: isLiked
                    ? const Color.fromARGB(255, 0, 183, 255) // اللون عند الإعجاب
                    : const Color.fromARGB(255, 255, 255, 255), // اللون عند عدم الإعجاب
              ),
            ),
            Text("$likeCount"),
          ],
        ),
        const SizedBox(width: 20), // إضافة مسافة بين الزرين

        // زر التعليقات مع عدد التعليقات
        Row(
          children: [
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNames.addReply, arguments: widget.post);
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            Text("${widget.post.commentCount}"),
          ],
        ),
      ],
    );
  }
}
