
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ImageDisplayPage extends StatelessWidget {
  final String imagePath;
  final bool isFile;
  final String text;

  ImageDisplayPage({required this.imagePath, required this.isFile, required this.text, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Display"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: isFile
                  ? Image.file(
                File(imagePath),
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                imagePath,
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              text,
               // Display the passed text
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
