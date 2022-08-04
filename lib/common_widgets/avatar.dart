// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.photoUrl, required this.radius, this.color}) : super(key: key);

final String? photoUrl;
final double radius;
final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color!,
          width: 3.0,
        )
      ),
      child: CircleAvatar(
        backgroundColor: Colors.black12,
        radius: radius,
        backgroundImage: photoUrl !=null ? NetworkImage(photoUrl!) : null,
        child: photoUrl == null ? Icon(Icons.camera_alt, size:radius) : null,
      ),
    );
  }
}