import 'dart:io';
import 'package:flex/models/post_model.dart';
import 'package:flex/models/reply_model.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/env.dart';
import 'package:flex/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  var content = "".obs;
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var showPostLoading = false.obs;
  Rx<PostModel> post = Rx<PostModel>(PostModel());
  var showReplyLoading = false.obs;
  RxList<ReplyModel> replies = RxList<ReplyModel>();

  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) {
      image.value = file;
    }
  }

  void store(String userId) async {
    try {
      loading.value = true;
      const uuid = Uuid();
      final dir = "$userId/${uuid.v6()}";
      var imgPath = "";

      if (image.value != null && image.value!.existsSync()) {
        imgPath = await SupabaseService.SupabaseClient.storage
            .from(Env.s3Bucket)
            .upload(dir, image.value!);
      }

      // اضافة المنشور الى قاعدة البيانات
      await SupabaseService.SupabaseClient.from("posts").insert({
        "user_id": userId,
        "content": content.value,
        "image": imgPath.isNotEmpty ? imgPath : null,
      });
      loading.value = false;
      resetState();
      Get.find<NavigationService>().currentIndex.value = 0;
      showSnackBar("Success", "Post added successfully!");
    } on StorageException catch (error) {
      showSnackBar("Error", error.message);
    } catch (error) {
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // لإظهار صفحة المنشور
  void show(int postId) async {
    try {
      post.value = PostModel();
      replies.value = [];
      showPostLoading.value = true;
      final response =
          await SupabaseService.SupabaseClient.from("posts").select('''
        id, content, image, created_at, comment_count, like_count, user_id,
        user:user_id (
          id, email, metadata, is_verified
        ),
        likes:likes (user_id, post_id)
      ''').eq("id", postId).single();

      showPostLoading.value = false;
      post.value = PostModel.fromJson(response);

      // جلب التعليقات
      fetchPostReplies(postId);
    } catch (e) {
      showPostLoading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // جلب تعليقات المنشور
  void fetchPostReplies(int postId) async {
    try {
      showReplyLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.SupabaseClient.from("comments").select('''
        id, user_id, post_id, reply, created_at,
        user:user_id (
          email, metadata, is_verified
        )
      ''').eq("post_id", postId);
      
      showReplyLoading.value = false;
      if (response.isNotEmpty) {
        replies.value = [for (var item in response) ReplyModel.fromJson(item)];
      }
    } catch (e) {
      showReplyLoading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // دالة لإضافة إعجاب
  Future<void> likePost(int postId, String userId) async {
    try {
      // إضافة إعجاب إلى جدول likes
      await SupabaseService.SupabaseClient.from('likes').insert({
        'user_id': userId,
        'post_id': postId,
      });

      // زيادة عدد الإعجابات في جدول posts
      await SupabaseService.SupabaseClient.rpc('like_increment', params: {
        'count': 1,
        'row_id': postId,
      });

      // إضافة إشعار بالإعجاب
      await SupabaseService.SupabaseClient.from("notifications").insert({
        "user_id": userId,
        "notification": "Raised your post",
        "to_user_id": post.value.userId,
        "post_id": postId
      });

      print("Post liked successfully.");
    } catch (e) {
      print("Error liking post: $e");
      showSnackBar("Error", "Could not like the post.");
    }
  }

  // دالة لإزالة إعجاب
  Future<void> dislikePost(int postId, String userId) async {
    try {
      // إزالة الإعجاب من جدول likes
      await SupabaseService.SupabaseClient.from('likes')
          .delete()
          .match({"user_id": userId, "post_id": postId});

      // تقليل عدد الإعجابات في جدول posts
      await SupabaseService.SupabaseClient.rpc('like_dencrement', params: {
        'count': 1,
        'row_id': postId,
      });

      print("Post disliked successfully.");
    } catch (e) {
      print("Error disliking post: $e");
      showSnackBar("Error", "Could not dislike the post.");
    }
  }

  // لإعادة تعيين صفحة كتابة المنشور بعد نشره
  void resetState() {
    content.value = "";
    image.value = null;
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
