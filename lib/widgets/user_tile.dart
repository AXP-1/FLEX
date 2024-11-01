import 'package:flex/models/user_model.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/utils/styles/button_styles.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: CircleImage(
          url: user.metadata?.image,
        ),
      ),
      title: Row(
        children: [
          Text(
            user.metadata!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          if (user.isVerified == true)
            const Icon(
              Icons.verified,
              color: Colors.blue,
              size: 16,
            ),
        ],
      ),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: OutlinedButton(
        onPressed: () => Get.toNamed(RouteNames.showUser, arguments: user.id),
        style: customOutlineStyle(context),
        child: const Text("View Profile"),
      ),
      subtitle: Text(user.metadata!.description!),
    );
  }
}