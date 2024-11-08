import 'package:flex/controllers/profile_controller.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/utils/styles/button_styles.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/reply_card.dart';
import 'package:flex/widgets/loading.dart';
import 'package:flex/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController controller = Get.put(ProfileController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    if (supabaseService.currentUser.value?.id != null) {
      controller.fetchUserPosts(supabaseService.currentUser.value!.id);
      controller.fetchReplies(supabaseService.currentUser.value!.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" "),
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
                                  Row(
                                    children: [
                                      Text(
                                        supabaseService.currentUser.value!
                                            .userMetadata?["name"],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      if (controller.user.value.isVerified !=
                                              null &&
                                          controller.user.value.isVerified ==
                                              true)
                                        const Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: context.width * 0.60,
                                    child: Text(supabaseService
                                            .currentUser
                                            .value
                                            ?.userMetadata?["description"] ??
                                        "Flex User"),
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              final imageUrl = supabaseService
                                  .currentUser.value?.userMetadata?["image"];
                              if (imageUrl != null) {
                                Get.toNamed(RouteNames.showImage,
                                    arguments: imageUrl);
                              }
                            },
                            child: CircleImage(
                              radius: 40,
                              url: supabaseService
                                  .currentUser.value?.userMetadata?["image"],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Get.toNamed(RouteNames.editProfile),
                              style: customOutlineStyle(context),
                              child: const Text("Edit Profile"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                final userName = supabaseService
                                    .currentUser.value?.userMetadata?["name"];
                                if (userName != null) {
                                  Clipboard.setData(
                                      ClipboardData(text: userName));
                                  showSnackBar("Copied",
                                      "Username copied to clipboard!");
                                }
                              },
                              style: customOutlineStyle(context),
                              child: const Text("Copy Name"),
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
                delegate: SliverAppBarDelegate(TabBar(
                  tabs: const [
                    Tab(text: "Posts"),
                    Tab(text: "Replies"),
                  ],
                  indicatorColor:
                      Theme.of(context).colorScheme.primary, // لون المؤشر
                  labelColor: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color, // لون التبويب المحدد
                  unselectedLabelColor: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color, // لون التبويب غير المحدد
                )),
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
                            itemBuilder: (context, index) => PostCard(
                              post: controller.posts[index],
                              isAuthCard: true,
                              callback: controller.deletePost,
                            ),
                          )
                        else
                          const Center(
                            child: Text(
                                "No Posts found, try to write something :)"),
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
                            itemBuilder: (context, index) => ReplyCard(
                              reply: controller.replies[index],
                              isAuthCard: true,
                              callback: controller.deleteReply,
                            ),
                          )
                        else
                          const Center(
                            child: Text(
                                "No Replies yet to show, try to write a reply to someone :)"),
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

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  SliverAppBarDelegate(this._tabBar);

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor, // اجعل اللون يعتمد على الخلفية الافتراضية
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
