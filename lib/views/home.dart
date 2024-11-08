import 'package:flex/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final NavigationService navigationService = Get.put(NavigationService());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationService.currentIndex.value,
          onDestinationSelected: (value) =>
          navigationService.updateIndex(value),
          
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              label: "Search",
              selectedIcon: Icon(Icons.search),
            ),
            NavigationDestination(
              icon: Icon(Icons.add_outlined),
              label: "Add Post",
              selectedIcon: Icon(Icons.add),
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              label: "Notifications",
              selectedIcon: Icon(Icons.notifications),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: "Profile",
              selectedIcon: Icon(Icons.person),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(microseconds: 500),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.easeOut,
          child:
              navigationService.pages()[navigationService.currentIndex.value],
        ),
      ),
    );
  }
}
