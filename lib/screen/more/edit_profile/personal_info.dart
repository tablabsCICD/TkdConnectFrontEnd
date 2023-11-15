import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/images.dart';

import '../../../generated/l10n.dart';
import '../../../provider/edit_profile/edit_profile_provider.dart';
import '../../../widgets/editText.dart';

class PersonalInfoScreen extends StatefulWidget {
   EditProfileProvider editProfileProvider;
 PersonalInfoScreen({super.key, required this.editProfileProvider});
  @override
  State<StatefulWidget> createState() {
   return _EditProfileState();
  }

}
class _EditProfileState extends State<PersonalInfoScreen>{



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => widget.editProfileProvider,
      builder: (context, child) => _buildPage(context),
    );
  }
  _buildPage(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(left: 20.w,right: 20.w),
        child: Container(

            child: Column(
              children: [
                SizedBox(height: 28.h,),
                editProfile(),
                SizedBox(height: 28.h,),

                labelText(S().firstName,),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egFristName,widget.editProfileProvider.firstNameController),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().lastName),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egLastName,widget.editProfileProvider.lastNameController),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().email_id),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egMail,widget.editProfileProvider.emailNameController,redOnly: true),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().mobileNumber),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egMobile,widget.editProfileProvider.mobileNameController,redOnly: true),
                SizedBox(
                  height: 4.h,
                ),
              ],
            )

        ),
      ),
    );
  }

  editProfile(){
    return InkWell(
      onTap: (){
        widget.editProfileProvider.editProfileImage(context);
      },
      child: Container(
        width: 100.w,
        height: 100.h,
        child: widget.editProfileProvider.profilePic==""?SvgPicture.asset(Images.edit_profile):Image.network(widget.editProfileProvider.profilePic),
      ),
    );
  }


  labelText(String label) {
    return Container(
      width: 332.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  editView(String hint, TextEditingController controller,{bool redOnly=false}) {
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      readOnly: redOnly,
      onChange: (val){
       // provider.checkValidation();
      },
    );
  }




}