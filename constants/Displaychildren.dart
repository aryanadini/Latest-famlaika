import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/addmember/addmember_view.dart';
import '../widgets/GradientButton.dart';

class DisplayChildren extends StatelessWidget {
  final double imagehgt;
  final double imagewdt;
  final double imagebradius;
  final double cthgt;
  final double ctwdt;
  final String imageUrl;
  final String persongname;
  final String personrelation;
  final bool isEditoraddmember;
  final bool isDeleteMember;
  final String relationType;
  final int relation_id;
  final VoidCallback? onPressed;
  final Function(int) onDelete;

  DisplayChildren(
      {super.key,
        required this.imagehgt,
        required this.imagewdt,
        required this.imagebradius,
        required this.cthgt,
        required this.imageUrl,
        required this.persongname,
        required this.personrelation,
        required this.ctwdt,
        required this.relationType,
        required this.relation_id,
        this.isEditoraddmember=true,
        this.isDeleteMember = true,
        required this.onDelete,
        this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ScreenUtil().setHeight(cthgt + imagehgt),
        width: ScreenUtil().setWidth(ctwdt + imagewdt),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              // left: ScreenUtil().setWidth((ctwdt + imagewdt - ctwdt) / 2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Color(0xFF383838),
                ),
                height: ScreenUtil().setHeight(cthgt),
                width: ScreenUtil().setWidth(ctwdt),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      persongname.length > 15 ? persongname.substring(0, 12) + '...' : persongname,
                      style: TextStyle(fontSize: 16.sp, color: Color(0xFFFFFFFFFF),fontWeight: FontWeight.w400),
                    ),
                    Text(
                      personrelation ?? "Relation",
                      style: TextStyle(fontSize: 10.sp, color: Color(0xFFFFFFFFFF),fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(12),
              left: ScreenUtil().setWidth((ctwdt - imagewdt) / 2),
              child: Container(
                height:ScreenUtil().setHeight(imagehgt),
                width: ScreenUtil().setWidth(imagewdt),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                    topLeft: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                  ),
                  border: Border.all(
                    width:ScreenUtil().setWidth(1),

                    color: Color(0xFFF7B52C),
                  ),),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                      bottomRight: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                      topLeft: Radius.circular(ScreenUtil().setWidth(imagebradius)),
                    ),
                    child:  imageUrl.startsWith('http')
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),

                  ),
                ),
              ),

            if (isEditoraddmember)
              Positioned(
                bottom: ScreenUtil().setHeight(45),
                right: ScreenUtil().setWidth(85),
                child: Container(
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade300,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: FaIcon(FontAwesomeIcons.penToSquare, color: Color(0xFFFFFFFF), size: 20),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          int gender;
                          // Only use relationType if it's the Editoraddmember page
                          if (relationType == "Father" || relationType == "Spouse") {
                            gender = 1; // Assuming 1 is for male
                          } else if (relationType == "Mother" || relationType == "Sister") {
                            gender = 2; // Assuming 2 is for female
                          } else {
                            gender = 3; // Assuming 3 is for other (you can define this as needed)
                          }
                          return Addmember(
                            defaultMale: gender == 1,
                            isGenderFixed: true,
                            relation: relationType, gender: gender,
                          );
                        }));
                      },
                    ),
                  ),
                ),
              ),
            if (isDeleteMember)
              Positioned(
                bottom: ScreenUtil().setHeight(45),
                right: ScreenUtil().setWidth(85),
                child: Container(
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade200,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(CupertinoIcons.delete_simple, color: Colors.white, size: 20),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.delete_simple, color: Colors.white, size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Do you really want to delete ${persongname ?? 'this.person'}(${personrelation ?? 'this relation'}) from the family tree?',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GradientButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                        isSolidColor: true,
                                        solidColor: Colors.grey,



                                      ),
                                      GradientButton(
                                        onPressed: () async{

                                          //  await deleteProfile(profile['rid']);
                                          try {
                                            // Attempt to delete using the callback and await any async operations
                                            final bool? result = await onDelete(relation_id);
                                            if (result == null) {
                                              // Handle the null case if needed
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('An unexpected error occurred.'),
                                                  backgroundColor: Colors.red,
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );

                                              return; // Exit the function
                                            }

                                            // If deletion is successful, show success message
                                            if (result) {

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Member successfully deleted from the family tree.'),
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                              Navigator.pop(context, result);
                                            }
                                            else {
                                              Navigator.pop(context, false);
                                            }
                                          } catch (e) {
                                            // Catch any unexpected errors and display an error message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('An error occurred. Please try again later.'),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            print('Error deleting member: $e');
                                            Navigator.pop(context, false);// Log the error for debugging
                                          }
                                        },
                                        child: Text('Confirm'),








                                      )


                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        // Define your delete logic here
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DisplaySmallchildWidget extends StatelessWidget {
  late double simagehgt;
  late double simagewdt;
  late double simagebradius;
  String? childimage;
  String? stext;
  late String childname;
  late final bool showVerticalLine;
  DisplaySmallchildWidget({
    super.key,
    required this.simagehgt,
    required this.simagewdt,
    required this.simagebradius,
    required this.childname,
    this.childimage,
    this.stext,
    this.showVerticalLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: simagehgt + (MediaQuery.of(context).size.width * 0.1),
      width: simagewdt,
      child: Stack(
        children: [
          if (showVerticalLine)
            Positioned(
                top: -1.h,
                left: ScreenUtil().setWidth(simagewdt) / 2,
                child: CCContainer(
                  cheight: ScreenUtil().setHeight(MediaQuery.of(context).size.width * 0.1),
                  cwidth: 1,
                )),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height:ScreenUtil().setHeight(simagehgt),
              width:ScreenUtil().setWidth(simagewdt),
              decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  image: childimage != null
                      ? DecorationImage(
                    image: NetworkImage(childimage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(ScreenUtil().setWidth(simagebradius)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(simagebradius)),
                    topLeft: Radius.circular(ScreenUtil().setWidth(simagebradius)),

                  ),
                  border: Border.all(
                    width: ScreenUtil().setWidth(1),
                    color: Color(0xFFF7B52C),
                  )),



              child: childimage == null
                  ? Center(
                child: Text(
                  stext ?? "",
                  style: TextStyle(fontSize: 16.sp, color: Color(0xFF000000),fontWeight: FontWeight.w400),
                ),
              )
                  : null,
            ),
          ),


        ],
      ),
    );
  }
}

class CCContainer extends StatelessWidget {
  final double cheight;
  final double cwidth;
  CCContainer({super.key, required this.cheight, required this.cwidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7B52C),
      height: ScreenUtil().setHeight(cheight),
      width: ScreenUtil().setWidth(cwidth),
    );
  }
}