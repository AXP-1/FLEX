import 'package:flex/controllers/notification_controller.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/services/navigation_service.dart';
import 'package:flex/services/supabase_service.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/widgets/circle_image.dart';
import 'package:flex/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller
        .fetchNotifications(Get.find<SupabaseService>().currentUser.value!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.find<NavigationService>().backToPrevPage(),
              icon: const Icon(Icons.close)),
          title: const Text("Notifications"),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => controller.loading.value
                ? const Loading()
                : Column(
                    children: [
                      if (controller.notifications.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.notifications.length,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () => {
                              Get.toNamed(RouteNames.showPost, arguments: controller.notifications[index].postId)
                            },
                            leading: CircleImage(
                              url: controller
                                  .notifications[index].user?.metadata?.image,
                            ),
                            title: Text(controller
                                .notifications[index].user!.metadata!.name!),
                            trailing: Text(formatDateFromNow(
                                controller.notifications[index].createdAt!)),
                            subtitle: Text(
                                controller.notifications[index].notification!),
                          ),
                        )
                        else
                        const Text("No Notification found, keep up to date")
                    ],
                  ),
          ),
        ));
  }
}
