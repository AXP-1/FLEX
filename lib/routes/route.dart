import 'package:flex/routes/route_names.dart';
import 'package:flex/views/auth/login.dart';
import 'package:flex/views/auth/register.dart';
import 'package:flex/views/posts/show_image.dart';
import 'package:flex/views/posts/show_post.dart';
import 'package:flex/views/profile/edit_profile.dart';
import 'package:flex/views/profile/profile.dart';
import 'package:flex/views/profile/show_user.dart';
import 'package:flex/views/replies/add_reply.dart';
import 'package:flex/views/settings/settings.dart';
import 'package:get/route_manager.dart';
import 'package:flex/views/home.dart';

class Routes {
  static final pages = [
    GetPage(
      name: RouteNames.home,
      page: () =>  Home(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.login,
      page: () => const Login(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.register,
      page: () => const Register(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.profile,
      page: () => const Profile(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.editProfile,
      page: () => const EditProfile(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.settings,
      page: () => Settings(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.addReply,
      page: () => AddReply(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.showPost,
      page: () => const ShowPost(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.showImage,
      page: () => ShowImage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.showUser,
      page: () => const ShowUser(),
      transition: Transition.fade,
    ),
  ];
}
