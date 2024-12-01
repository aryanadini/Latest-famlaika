import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../apiservice/api_services.dart';
import '../pages/addmember/addmember_view.dart';
import '../pages/homefamilytree/EditAddmember.dart';
import '../pages/homefamilytree/homesub/home2.dart';
import '../widgets/GradientButton.dart';

class DisplaySibling extends StatefulWidget {
  final Map<String, dynamic>? profile;


  double cthgt;
  double ctwdt;
  double imagehgt;
  double imagewdt;
  double imagebradius;
  final String imageUrl;
  final String persongname;
  final String personrelation;
  String? relationType;
  final int? gender;
  final String? mobileNumber;
  bool isEditoraddmember;
  final String? dateOfBirth;
  bool isDeleteMember;
  final int? relation;
  final bool isGenderFixed;
  final int relation_id;

  final VoidCallback onEdit;

  final Function(int) onDelete;
  final VoidCallback? onPressed;

  DisplaySibling({super.key,
    required this.imagehgt,
    required this.imagewdt,
    required this.imagebradius,
    required this.cthgt,
    required this.imageUrl,
    required this.persongname,
    required this.personrelation,
    required this.ctwdt,
    required this.relation_id,
    this.isGenderFixed = false,

    this.relation,
    this.relationType,
    this.isEditoraddmember = true,
    this.isDeleteMember = true,
    this.profile,
    required this.onDelete,
    required this.onEdit,

    this.onPressed, this.dateOfBirth, this.mobileNumber, this.gender});

  late bool female;

  @override
  State<DisplaySibling> createState() => _DisplaySiblingState();
}

class _DisplaySiblingState extends State<DisplaySibling> {

  final ApiService apiService = ApiService();
  TextEditingController _RelationController = TextEditingController();
  String selectedRelation = '';
  bool isSibling = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateRelationOptions();

  }
  void _updateRelationOptions() {
    selectedRelation = '';
    isSibling = false;
    late bool female;
    // Check if gender is fixed
    if (widget.isGenderFixed) {
      if (widget.gender == 2) {
        // For Female
        selectedRelation = (widget.relation == 'Spouse') ? 'Spouse' : 'Mother';
      } else if (widget.gender == 1) {
        // For Male
        selectedRelation = (widget.relation == 'Spouse') ? 'Spouse' : 'Father';
      }
    } else {
      // Gender is not fixed
      if (widget.relation == 'Spouse') {
        // If relation is Spouse, set selectedRelation based on defaultMale logic
        selectedRelation = widget.female ? 'Spouse' : 'Spouse';
      } else if (widget.relation == 'Brother') {
        // Handle sibling relation when gender is not fixed
        selectedRelation = widget.female ? 'Sister' : 'Brother'; // Assuming `female` is a boolean indicating the gender
      } else if (widget.relation == 'Son') {
        // Handle sibling relation when gender is not fixed
        selectedRelation = widget.female ? 'Daughter' : 'Son'; // Assuming `female` is a boolean indicating the gender
      }
    }

    // Set the text controller and print debug info
    _RelationController.text = selectedRelation;
    print('Gender: ${widget.gender}');
    print('Is Gender Fixed: ${widget.isGenderFixed}');
    print('Selected Relation: $selectedRelation');
    print('Is Sibling: $isSibling');
  }

  void _deleteMember() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bool? result = await widget.onDelete(widget.relation_id);
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Member successfully deleted from the family tree.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home2(accessToken: '', userId: '',)),
        );
      } else {
        Navigator.pop(context, false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      print('Error deleting member: $e');
      Navigator.pop(context, false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: ScreenUtil().setHeight(widget.cthgt + widget.imagehgt),
        width: ScreenUtil().setWidth(widget.ctwdt + widget.imagewdt),
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
                height: ScreenUtil().setHeight(widget.cthgt),
                width: ScreenUtil().setWidth(widget.ctwdt),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.persongname.length > 12 ? widget.persongname.substring(0, 12) +
                          '...' : widget.persongname,
                      style: TextStyle(fontSize: 16.sp,
                          color: Color(0xFFFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.personrelation ?? "Relation",
                      style: TextStyle(fontSize: 10.sp,
                          color: Color(0xFFFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(12),
              left: ScreenUtil().setWidth((widget.ctwdt - widget.imagewdt) / 2),
              child: Container(
                height: ScreenUtil().setHeight(widget.imagehgt),
                width: ScreenUtil().setWidth(widget.imagewdt),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                    bottomRight: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                    topLeft: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                  ),
                  border: Border.all(
                    width: ScreenUtil().setWidth(1),

                    color: Color(0xFFF7B52C),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                    bottomRight: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                    topLeft: Radius.circular(
                        ScreenUtil().setWidth(widget.imagebradius)),
                  ),
                  child: widget.imageUrl.startsWith('http')
                      ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),

                ),
              ),
            ),
            if (widget.isEditoraddmember)
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
                      icon: FaIcon(FontAwesomeIcons.penToSquare,
                          color: Color(0xFFFFFFFF), size: 20),
                      onPressed: () async {
                        print("Name: ${widget.persongname}");
                      print("Relation: ${widget.personrelation}");
                      print("Date of Birth: ${widget.dateOfBirth}");
                      print("Mobile Number: ${widget.mobileNumber}");
                      print("Gender: ${widget.gender}");
                      print("Profile Pic: ${widget.imageUrl}");
                        print('Default Male: ${widget.gender == 1}');

                        String relation = widget.personrelation.trim().toUpperCase();
                        print("Trimmed Relation: '$relation'");
                        int gender;
                        //Only use relationType if it's the Editoraddmember page
                        switch (relation) {
                          case "FATHER":
                          case "SPOUSE":
                          case "SON":
                            gender = 1; // Male
                            break;
                          case "MOTHER":
                          case "SISTER":
                          case "DAUGHTER":
                            gender = 2; // Female
                            break;
                          default:
                            gender = 3; // Other
                            break;
                        }
                        print("Determined Gender: $gender");

                      Navigator.push(context, MaterialPageRoute(builder: (
                            context) {
                          return EditAddmember(

                            name: widget.persongname ?? 'Not provided',
                              relation: widget.personrelation ?? 'Not provided', // Assuming personrelation is already a string
                            dateOfBirth: widget.dateOfBirth ?? 'Not provided',
                            mobile: widget.mobileNumber ?? 'Not provided',
                           // gender: widget.gender,
                            profilePic: widget.imageUrl,
                              defaultMale: gender == 1,
                            isGenderFixed: true,
                              gender:gender,


                          );

                        }
                        )).then((_) {
                       // print("Gender after navigation: $gender");
                      });
                        print("Initializing EditMember with2:");
                        print("Name: ${widget.persongname}");
                        print("Relation: ${widget.personrelation}");
                        print("Date of Birth: ${widget.dateOfBirth}");
                        print("Mobile Number: ${widget.mobileNumber}");
                        print("Gender: $gender");
                        print("Profile Pic: ${widget.imageUrl}");
                      },
                    ),
                  ),
                ),
              ),
            if (widget.isDeleteMember)
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
                      icon: Icon(
                          CupertinoIcons.delete_simple, color: Colors.white,
                          size: 20),
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
                                  Icon(CupertinoIcons.delete_simple,
                                      color: Colors.white, size: 40),
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
                                    'Do you really want to delete ${widget.persongname ??
                                        'this.person'}(${widget.personrelation ??
                                        'this relation'}) from the family tree?',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      GradientButton(
                                        onPressed: () {
                                          Navigator.pop(context,true);

                                        },
                                        child: Text('Cancel'),
                                        isSolidColor: true,
                                        solidColor: Colors.grey,


                                      ),
                                      GradientButton(
                                        onPressed: _deleteMember,
                                        //     () async{
                                        //
                                        // //  await deleteProfile(profile['rid']);
                                        //   try {
                                        //     // Attempt to delete using the callback and await any async operations
                                        //     final bool? result = await widget.onDelete(widget.relation_id);
                                        //     if (result == null) {
                                        //       // Handle the null case if needed
                                        //       ScaffoldMessenger.of(context).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text('An unexpected error occurred.'),
                                        //           backgroundColor: Colors.red,
                                        //           duration: Duration(seconds: 2),
                                        //         ),
                                        //       );
                                        //
                                        //       return; // Exit the function
                                        //     }
                                        //
                                        //     // If deletion is successful, show success message
                                        //     if (result) {
                                        //
                                        //       ScaffoldMessenger.of(context).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text('Member successfully deleted from the family tree.'),
                                        //           backgroundColor: Colors.green,
                                        //           duration: Duration(seconds: 2),
                                        //         ),
                                        //       );
                                        //       Navigator.pop(context, result);
                                        //     }
                                        //     else {
                                        //       Navigator.pop(context, false);
                                        //     }
                                        //   } catch (e) {
                                        //     // Catch any unexpected errors and display an error message
                                        //     ScaffoldMessenger.of(context).showSnackBar(
                                        //       SnackBar(
                                        //         content: Text('An error occurred. Please try again later.'),
                                        //         backgroundColor: Colors.red,
                                        //         duration: Duration(seconds: 2),
                                        //       ),
                                        //     );
                                        //     print('Error deleting member: $e');
                                        //     Navigator.pop(context, false);// Log the error for debugging
                                        //   }
                                        // },
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
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMember() {
    int gender;
    String relation;

    switch (widget.relationType) {
      case "Father":
        gender = 1;
        relation = "FATHER";
        break;
      case "Mother":
        gender = 2;
        relation = "MOTHER";
        break;
      case "Spouse":
        gender = 1;
        relation = "SPOUSE";
        break;
      case "Brother":
        gender = 1;
        relation = "BROTHER";
        break;
      case "Sister":
        gender = 2;
        relation = "SISTER";
        break;
      case "Daughter":
        gender = 2;
        relation = "DAUGHTER";
        break;
      case "Son":
        gender = 1;
        relation = "SON";
        break;
      default:
        gender = 3; // Assuming 3 is for other
        relation = "UNKNOWN"; // Undefined relation
        break;
    }
  }

}
// void navigateToEditMember(BuildContext context, Map<String, dynamic> memberData) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => EditAddmember(memberData: memberData),
//     ),
//   );
// }

class DisplaySmallWidget extends StatelessWidget {
  double simagehgt;
  double simagewdt;
  double simagebradius;
  String? sinblingimage;
  String? stext;
  String siblingname;
  final bool showVerticalLine;
  DisplaySmallWidget({
    super.key,
    required this.simagehgt,
    required this.simagewdt,
    required this.simagebradius,
    required this.siblingname,
    this.sinblingimage,
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
                child: CContainer(
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
                  image: sinblingimage != null
                      ? DecorationImage(
                    image: NetworkImage(sinblingimage!),
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
              child: sinblingimage == null
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

class CContainer extends StatelessWidget {
  final double cheight;
  final double cwidth;
  CContainer({super.key, required this.cheight, required this.cwidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7B52C),
      height: ScreenUtil().setHeight(cheight),
      width: ScreenUtil().setWidth(cwidth),
    );
  }
}
