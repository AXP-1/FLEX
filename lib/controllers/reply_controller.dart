import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyController extends GetxController {
  final TextEditingController replyController = TextEditingController(text: "");
  var loading = false.obs;
  var reply = "".obs;

  void addReply(String userId, int postId, String postUserId) async {
    try {
      loading.value = true;

      // زيادة رقم التعليقات
      await SupabaseService.SupabaseClient.rpc("comment_increment",
          params: {"count": 1, "row_id": postId});

      // اضافة الاشعار
      await SupabaseService.SupabaseClient.from("notifications").insert({
        "user_id": userId,
        "notification": "Commented: ${reply.value}",
        "to_user_id": postUserId,
        "post_id": postId
      });

      // اضافة التعليق في جدول التعليقات 
      await SupabaseService.SupabaseClient.from("comments").insert({
        "post_id": postId,
        "user_id": userId,
        "reply": replyController.text
      });

      loading.value = false;
      showSnackBar("Success", "Replied successfully!");
    } catch (e) {
      loading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  @override
  void onClose() {
    replyController.dispose();
    super.onClose();
  }
}
