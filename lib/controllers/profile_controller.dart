import 'dart:io';
import 'package:flex/models/post_model.dart';
import 'package:flex/models/reply_model.dart';
import 'package:flex/models/user_model.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/env.dart';
import 'package:flex/utils/helper.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var postLoading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var replyLoading = false.obs;
  RxList<ReplyModel> replies = RxList<ReplyModel>();
  var followLoading = false.obs;
  var userLoading = false.obs;
  var isFollowing = false.obs;
  Rx<UserModel> user = Rx<UserModel>(UserModel());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  // تحديث الصورة الشخصية
  Future<void> updateProfile(String userId, String description) async {
    try {
      loading.value = true;
      var uploadedPath = "";
      if (image.value != null && image.value!.existsSync()) {
        final String dir = "$userId/profile.jpg";
        var path = await SupabaseService.SupabaseClient.storage
            .from(Env.s3Bucket)
            .upload(
              dir,
              image.value!,
              fileOptions: const FileOptions(upsert: true),
            );
        uploadedPath = path;
      }

      // تحديث صفحة المستخدم
      await SupabaseService.SupabaseClient.auth
          .updateUser(UserAttributes(data: {
        "description": description,
        "image": uploadedPath.isNotEmpty ? uploadedPath : null,
      }));

      loading.value = false;
      Get.back();
      showSnackBar("Success", "Profile has been updated successfully!");
    } on StorageException catch (error) {
      loading.value = false;
      showSnackBar("Error", error.message);
    } on AuthException catch (error) {
      loading.value = false;
      showSnackBar("Error", error.message);
    } catch (error) {
      loading.value = false;
      showSnackBar("Error", "Something went wrong, please try again.");
    }
  }

  // اختيار الصورة
  void pickImage() async {
    File? file = await pickImageFromGallery();
    if (file != null) image.value = file;
  }

  // جلب المستخدم
  void fetchUser(String userId) async {
    try {
      userLoading.value = true;
      final response = await SupabaseService.SupabaseClient.from("users")
          .select("*")
          .eq("id", userId)
          .single();
      userLoading.value = false;
      user.value = UserModel.fromJson(response);

      // جلب منشورات وتعليقات المستخدم
      fetchUserPosts(userId);
      fetchReplies(userId);
    } catch (e) {
      userLoading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // جلب المنشورات الخاصة بالمستخدم في صفحته الشخصية
  void fetchUserPosts(String userId) async {
    try {
      postLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.SupabaseClient.from("posts").select('''
    id, content, image, created_at, comment_count, like_count, user_id, user:user_id (email, metadata, is_verified), likes:likes (user_id, post_id)
''').eq("user_id", userId).order("id", ascending: false);
      postLoading.value = false;
      if (response.isNotEmpty) {
        posts.value = [for (var item in response) PostModel.fromJson(item)];
      }
    } catch (e) {
      postLoading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // جلب التعليقات الخاصة بالمستخدم في صفحته الشخصية
  void fetchReplies(String userId) async {
    try {
      replyLoading.value = true;
      final List<dynamic> response =
          await SupabaseService.SupabaseClient.from("comments").select('''
id, user_id, post_id, reply, created_at, user:user_id (email, metadata, is_verified)
''').eq("user_id", userId).order("id", ascending: false);
      replyLoading.value = false;
      if (response.isNotEmpty) {
        replies.value = [for (var item in response) ReplyModel.fromJson(item)];
      }
      replyLoading.value = false;
    } catch (e) {
      replyLoading.value = false;
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // حذف منشور
  Future<void> deletePost(int postId) async {
    try {
      await SupabaseService.SupabaseClient.from("posts")
          .delete()
          .eq("id", postId);
      posts.removeWhere((element) => element.id == postId);
      if (Get.isDialogOpen == true) Get.back();
      showSnackBar("Success", "Post has been deleted!");
    } catch (e) {
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // حذف تعليق
  Future<void> deleteReply(int replyId) async {
    try {
      await SupabaseService.SupabaseClient.from("comments")
          .delete()
          .eq("id", replyId);
      replies.removeWhere((element) => element.id == replyId);
      if (Get.isDialogOpen == true) Get.back();
      showSnackBar("Success", "Reply has been deleted!");
    } catch (e) {
      showSnackBar("Error", "Something went wrong!");
    }
  }

  // متابعة مستخدم جديد
  Future<void> followUser(String currentUserId, String followedUserId) async {
  try {
    final response = await SupabaseService.SupabaseClient
        .from('users')
        .select('following')
        .eq('id', currentUserId)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return;
    }

    List<dynamic> followingList = response['following'] ?? [];
    if (!followingList.contains(followedUserId)) {
      followingList.add(followedUserId);
    }

    final updateResponse = await SupabaseService.SupabaseClient
        .from('users')
        .update({'following': followingList})
        .eq('id', currentUserId)
        .select();

    if (updateResponse == null || updateResponse.isEmpty) {
    } else {


      user.update((u) {
        u?.following?.add(followedUserId);
      });

      // إضافة الإشعار إلى المستخدم الذي تمت متابعته
      await SupabaseService.SupabaseClient.from("notifications").insert({
        "user_id": currentUserId,
        "notification": "Started following you!",
        "to_user_id": followedUserId,
      });
    }
  } catch (e) {
    print("Unexpected error: $e");
  }
}


  // إلغاء متابعة مستخدم
  Future<void> unfollowUser(String currentUserId, String followedUserId) async {
    try {
      final response = await SupabaseService.SupabaseClient
          .from('users')
          .select('following')
          .eq('id', currentUserId)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return;
      }

      List<dynamic> followingList = response['following'] ?? [];
      if (followingList.contains(followedUserId)) {
        followingList.remove(followedUserId);
      }

      final updateResponse = await SupabaseService.SupabaseClient
          .from('users')
          .update({'following': followingList})
          .eq('id', currentUserId)
          .select();

      if (updateResponse == null || updateResponse.isEmpty) {
      } else {
        user.update((u) {
          u?.following?.remove(followedUserId);
        });
      }
    } catch (e) {
      print("Unexpected error: $e");
    }
  }
  // التحقق مما إذا كان المستخدم الحالي يتابع المستخدم المستعرض
Future<void> checkIfFollowing(String currentUserId, String targetUserId) async {
  try {
    userLoading.value = true;
    final response = await SupabaseService.SupabaseClient
        .from('users')
        .select('following')
        .eq('id', currentUserId)
        .limit(1)
        .maybeSingle();

    userLoading.value = false;

    if (response == null) {
      return;
    }

    List<dynamic> followingList = response['following'] ?? [];
    isFollowing.value = followingList.contains(targetUserId);
  } catch (e) {
    userLoading.value = false;
    print("Unexpected error: $e");
  }
}

}
