import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/registration_provider/user_details_provider.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';
import 'package:tkd_connect/widgets/sign_in_widget.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';


class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BaseScreen();
  }
}

class _BaseScreen extends State<PersonalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserDetailsProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor:ThemeColor.baground,
      body: SafeArea(

        child: Consumer<UserDetailsProvider>(
          builder: (context, provider, child) {
            return ListView(

              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: ThemeColor.baground,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 21.5.h,
                      ),
                      Textview(
                        title: S().registration_personal,
                        TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      progressBar(),
                      SizedBox(
                        height: 24.h,
                      ),
                      labelText(S().firstName,),
                      SizedBox(
                        height: 4.h,
                      ),
                      editView(S().egFristName,provider.firstNameController,provider),
                      SizedBox(
                        height: 12.h,
                      ),
                      labelText(S().lastName),
                      SizedBox(
                        height: 4.h,
                      ),
                      editView(S().egLastName,provider.lastNameController,provider),
                      SizedBox(
                        height: 12.h,
                      ),
                      labelText(S().email_id),
                      SizedBox(
                        height: 4.h,
                      ),
                      editView(S().egMail,provider.emailNameController,provider),
                      SizedBox(
                        height: 12.h,
                      ),
                      labelText(S().mobileNumber),
                      SizedBox(
                        height: 4.h,
                      ),
                      editView(S().egMobile,provider.mobileNameController,provider),
                      SizedBox(
                        height: 161.h,
                      ),
                      Consumer<UserDetailsProvider>(
                        builder: (context, provider, child) {
                          return Button(
                              width: 335.w,
                              height: 49.h,
                              title: S.current.Next,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                              isEnbale: provider.isEnbale,
                              onClick: () async{

                                provider.saveData(context);

                              });
                        },
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      const AlredayAccountWidget(),
                      SizedBox(
                        height: 10.h,
                      ),
                      supportNumber()
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }




  labelText(String label) {
    return SizedBox(
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

  editView(String hint, TextEditingController controller,UserDetailsProvider provider) {
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val){
        provider.checkValidation();
      },
    );
  }

  progressBar() {
    return SizedBox(
      width: 335.w,
      height: 6.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 335.w,
              height: 6.h,
              decoration: ShapeDecoration(
                color: const Color(0x4CB7B7B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 100.50.w,
              height: 6.h,
              decoration: ShapeDecoration(
                color: ThemeColor.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  supportNumber() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Textview(
                TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 12.sp,
                    color: Colors.black),
                title: S().helpSupport),
            InkWell(
              onTap: (){

              },
              child:

              Row(
                children: [
                  InkWell(

                    onTap: (){
                      Utils().callFunction("8123006888");
                    },child: subTitle('(+91)  8123006888 '),
                  ),
                  const Text(" / "),
                  InkWell(

                    onTap: (){
                      Utils().callFunction("8123004666");
                    },child:   subTitle('(+91)  8123004666 '),
                  ),
                ],
              )
              ,
            )
          ],
        ),
      ),
    );
  }


  subTitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        color: const Color(0xFFC3262C),
        fontSize: 10.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

}
