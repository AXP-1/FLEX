import 'package:flex/models/post_model.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/utils/type_def.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTopBar extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallback? callback;
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  final NavigationService navigationService = Get.find<NavigationService>();

  PostTopBar({
    required this.post,
    this.isAuthCard = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            final currentUserId = supabaseService.currentUser.value?.id;
            if (currentUserId != null && currentUserId == post.userId) {
              // المستخدم الحالي هو صاحب المنشور، توجه إلى صفحة الملف الشخصي
              navigationService.updateIndex(4); // فهرس صفحة Profile
            } else {
              // توجه إلى صفحة المستخدم الآخر
              Get.toNamed(RouteNames.showUser, arguments: post.userId);
            }
          },
          child: Row(
            children: [
              Text(
                post.user!.metadata!.name!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              if (post.user != null && post.user?.isVerified == true)
                const Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 16,
                ),
            ],
          ),
        ),
        Row(
          children: [
            Text(formatDateFromNow(post.createdAt!)),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () => {
                      confirmDialog("Are you sure?",
                          "Once it deleted, you won't be able to recover it!", () {
                        callback!(post.id!);
                      })
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(width: 1,)
          ],
        )
      ],
    );
  }
}
