import 'package:flex/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCardImage extends StatelessWidget {
  final String url;
  const PostCardImage({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.height * 0.60,
        maxWidth: context.width * 0.80,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // لون الظل
              spreadRadius: 1, // انتشار الظل
              blurRadius: 5, // مدى تشويش الظل
              offset: const Offset(0, 3), // إزاحة الظل
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            getS3Url(url),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}
