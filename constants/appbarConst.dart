import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actionWidget;

  CustomAppBar({required this.title, this.actionWidget,});

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.grey.shade900,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 12,),
            onPressed: () {
              // Handle back button press
              Navigator.pop(context, true);

            },
          ),
        ),
      ),
      title: Text(title,style: TextStyle(color: Color(0xFFFFFFFF),
          fontSize: 22.sp,
        fontFamily: 'Figtree',fontWeight: FontWeight.w600
      ),
      ),
      actions:actionWidget != null ?
      [actionWidget!]: null,
      // showActions  ? [
      //   TextButton(
      //     onPressed: () {
      //       // Handle skip button press
      //     },
      //     child: Text(
      //       "Skip",
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 14.sp,fontWeight: FontWeight.w400,
      //         fontFamily: "Figtree",
      //       ),
      //     ),
      //   ),
      // ]
      //   : null,
    );
  }
}