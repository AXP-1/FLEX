import 'package:flex/models/post_model.dart';
import 'package:flex/models/user_model.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  final String userId = Supabase.instance.client.auth.currentUser?.id ??
      ''; // الحصول على معرف المستخدم الحالي

  @override
  void onInit() async {
    if (userId.isNotEmpty) {
      await fetchPosts();
      listenChanges();
    } else {
      print('User ID not found.');
    }
    super.onInit();
  }

  Future<void> fetchPosts() async {
    try {
      loading.value = true;
      final currentUserId = SupabaseService.SupabaseClient.auth.currentUser?.id;

      if (currentUserId == null) {
        print("Error: User not logged in.");
        return;
      }

      // جلب قائمة المتابعين للمستخدم الحالي
      final userResponse = await SupabaseService.SupabaseClient.from("users")
          .select("following")
          .eq("id", currentUserId)
          .single();

      final followingIds = List<String>.from(userResponse['following'] ?? []);
      followingIds.add(currentUserId);
      final String orCondition =
          followingIds.map((id) => 'user_id.eq.$id').join(',');

      final List<dynamic> response =
          await SupabaseService.SupabaseClient.from("posts").select('''
          id, content, image, created_at, comment_count, like_count, user_id,
          user:user_id (email, metadata, is_verified), likes:likes (user_id, post_id)
        ''').or(orCondition).order("id", ascending: false);

      if (response.isNotEmpty) {
        posts.value = [for (var item in response) PostModel.fromJson(item)];
      }
    } catch (error) {
      print("Error fetching posts: $error");
      showSnackBar("Error", "Failed to fetch posts.");
    } finally {
      loading.value = false;
    }
  }

  // Listen Realtime post changes
  void listenChanges() async {
    SupabaseService.SupabaseClient.channel('public:posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'posts',
          callback: (payload) async {
            final PostModel post = PostModel.fromJson(payload.newRecord);
            if (post.userId == userId ||
                posts.any((p) => p.userId == post.userId)) {
              updateFeed(post);
            }
          },
        )
        .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'posts',
            callback: (payload) {
              posts.removeWhere(
                  (element) => element.id == payload.oldRecord["id"]);
            })
        .subscribe();
  }

  // لتحديث الصفحة الرئيسية
  void updateFeed(PostModel post) async {
    var user = await SupabaseService.SupabaseClient.from("users")
        .select("*")
        .eq("id", post.userId!)
        .single();

    post.likes = [];
    post.user = UserModel.fromJson(user);
    posts.insert(0, post);
  }
}
