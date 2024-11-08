import 'package:flex/models/reply_model.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/utils/type_def.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/reply_card_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyCard extends StatelessWidget {
  final ReplyModel reply;
  final bool isAuthCard;
  final DeleteCallback? callback;
  const ReplyCard({
    required this.reply,
    this.isAuthCard = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: CircleImage(
                url: reply.user?.metadata?.image,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: context.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReplyCardTopBar(
                    reply: reply,
                    isAuthCard: isAuthCard,
                    callback: callback,
                  ),
                  GestureDetector(
                    onTap: () => {
                        Get.toNamed(RouteNames.showPost, arguments: reply.id),
                      },
                    child: Text(reply.reply!)),
                ],
              ),
            )
          ],
        ),
        const Divider(
          color: Color(0xff242424),
        ),
      ],
    );
  }
}
