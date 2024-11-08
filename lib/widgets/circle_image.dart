import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex/utils/helper.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  const CircleImage({this.radius = 20, this.url, this.file, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (file != null)
          CircleAvatar(
            backgroundImage: FileImage(file!),
            radius: radius,
          )
        else if (url != null)
          CircleAvatar(
            radius: radius,
            backgroundImage: CachedNetworkImageProvider(
              getS3Url(url!),
            ),
          )
        else
          CircleAvatar(
            backgroundImage: const AssetImage("assets/image/avatar.png"),
            radius: radius,
          )
      ],
    );
  }
}
