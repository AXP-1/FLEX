import 'package:flex/models/post_model.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/utils/type_def.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/post_card_bottom_bar.dart';
import 'package:flex/widgets/post_card_image.dart';
import 'package:flex/widgets/post_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallback? callback;

  const PostCard({
    required this.post,
    this.isAuthCard = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                    PostTopBar(
                      post: post,
                      isAuthCard: isAuthCard,
                      callback: callback,
                    ),
                    GestureDetector(
                      onTap: () => {
                        Get.toNamed(RouteNames.showPost, arguments: post.id),
                      },
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunchUrl(Uri.parse(link.url))) {
                            await launchUrl(Uri.parse(link.url));
                          } else {
                            print("Could not open the link: ${link.url}");
                          }
                        },
                        text: post.content ?? "",
                        style: const TextStyle(fontSize: 14),
                        linkStyle: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (post.image != null)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.showImage,
                              arguments: post.image!);
                        },
                        child: PostCardImage(url: post.image!),
                      ),
                    PostCardBottomBar(post: post),
                  ],
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xff242424),
          ),
        ],
      ),
    );
  }
}
