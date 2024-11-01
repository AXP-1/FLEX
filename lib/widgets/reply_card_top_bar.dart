import 'package:flex/models/reply_model.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/utils/type_def.dart';
import 'package:flutter/material.dart';

class ReplyCardTopBar extends StatelessWidget {
  final ReplyModel reply;
  final bool isAuthCard;
  final DeleteCallback? callback;
  const ReplyCardTopBar({required this.reply,this.isAuthCard = false,
    this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          reply.user!.metadata!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(formatDateFromNow(reply.createdAt!)),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () => {
                      confirmDialog("Are you sure?",
                          "Once it deleted, you won't be able to recover it!",
                          () {
                        callback!(reply.id!);
                      })
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.more_horiz),
          ],
        )
      ],
    );
  }
}