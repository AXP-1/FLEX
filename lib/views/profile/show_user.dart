import 'package:flex/controllers/profile_controller.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/utils/styles/button_styles.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/views/profile/profile.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/loading.dart';
import 'package:flex/widgets/post_card.dart';
import 'package:flex/widgets/reply_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowUser extends StatefulWidget {
  const ShowUser({super.key});

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  final String userId = Get.arguments; // معرف المستخدم الذي نعرض حسابه
  final ProfileController controller = Get.put(ProfileController());
  final SupabaseService supabaseService = Get.find<SupabaseService>(); // للحصول على المستخدم الحالي

  @override
  void initState() {
    super.initState();
    controller.fetchUser(userId); // جلب بيانات المستخدم من قاعدة البيانات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.person),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(RouteNames.settings),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 160,
                collapsedHeight: 160,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.userLoading.value)
                                    const Loading()
                                  else
                                    const SizedBox(width: 5),
                                  Row(
                                    children: [
                                      Text(
                                        controller.user.value.metadata!.name!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (controller.user.value.isVerified == true)
                                        const Icon(Icons.verified,
                                            color: Colors.blue, size: 15),
                                    ],
                                  ),
                                  SizedBox(
                                    width: context.width * 0.60,
                                    child: Text(
                                      controller.user.value.metadata?.description ?? "Flex User",
                                    ),
                                  ),
                                ],
                              )),
                          CircleImage(
                            radius: 40,
                            url: controller.user.value.metadata?.image,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                final currentUserId =
                                    supabaseService.currentUser.value?.id;

                                if (currentUserId == null) {
                                  print("Error: User is not logged in.");
                                  return;
                                }

                                final isFollowing = controller
                                        .user.value.following
                                        ?.contains(userId) ?? false;

                                if (isFollowing) {
                                  controller.unfollowUser(currentUserId, userId); // إلغاء المتابعة
                                } else {
                                  controller.followUser(currentUserId, userId); // متابعة
                                }
                              },
                              style: customOutlineStyle(context),
                              child: Obx(() {
                                final isFollowing = controller
                                        .user.value.following
                                        ?.contains(userId) ?? false;
                                return Text(
                                    isFollowing ? "Following" : "Follow");
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: SliverAppBarDelegate(
                  const TabBar(tabs: [
                    Tab(text: "Posts"),
                    Tab(text: "Replies"),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Obx(() => SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        if (controller.postLoading.value)
                          const Loading()
                        else if (controller.posts.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.posts.length,
                            itemBuilder: (context, index) =>
                                PostCard(post: controller.posts[index]),
                          )
                        else
                          const Center(
                            child: Text("No Posts found, try to write something :)"),
                          )
                      ],
                    ),
                  )),
              Obx(() => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        if (controller.replyLoading.value)
                          const Loading()
                        else if (controller.replies.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.replies.length,
                            itemBuilder: (context, index) =>
                                ReplyCard(reply: controller.replies[index]),
                          )
                        else
                          const Center(
                            child: Text("No Replies yet to show, try to write a reply to someone :)"),
                          )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
