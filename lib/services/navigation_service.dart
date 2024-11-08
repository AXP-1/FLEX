import 'package:flex/views/home/home_page.dart';
import 'package:flex/views/notification/notifications.dart';
import 'package:flex/views/posts/add_post.dart';
import 'package:flex/views/profile/profile.dart';
import 'package:flex/views/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService extends GetxService{
  var currentIndex = 0.obs;
  var previousIndex = 0.obs;


  // all pages 
  List<Widget>pages(){
    return [
      HomePage(),
      const Search(),
      AddPost(),
      const Notifications(),
      const Profile(),
    ];
  }

  // العودة الى الصفحة السابقة
  void backToPrevPage(){
    currentIndex.value = previousIndex.value;
  }

  // update index
  void updateIndex(int index){
    previousIndex.value = currentIndex.value;
    currentIndex.value = index;
  }
}