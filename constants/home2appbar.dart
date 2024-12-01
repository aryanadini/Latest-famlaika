import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home2AppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? titleImage;
  final bool showActions;

  Home2AppBar({this.title, this.titleImage, this.showActions = true});

  @override
  Size get preferredSize => Size.fromHeight(61.h);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: Colors.grey.shade900,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'assets/images/menu_home.png', // Replace with your image asset path
                height: 10.h,
                width: 10.w,
                fit: BoxFit.scaleDown,
                color: Color(0xFFF7B52C),
              ),
            ),
          ),
          centerTitle: true,
          title: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: titleImage != null
                    ? Image.asset(titleImage!, height: 35.h)
                    : Text(
                  title ?? '',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 22.sp,
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: showActions
              ? [
            IconButton(
              onPressed: () {
                // Handle search button press
              },
              icon: Icon(Icons.search, color: Color(0xFFF7B52C), size: 24.sp),
            ),
            IconButton(
              onPressed: () {
                // Handle notifications button press
              },
              icon: Icon(Icons.notifications_none, color: Color(0xFFF7B52C), size: 24.sp),
            ),
          ]
              : null,
        ),
        Container(
          height: 1.h, // 1 pixel height for the divider
          color: Colors.grey.shade700, // Color of the divider
        ),
      ],
    );
  }
}
