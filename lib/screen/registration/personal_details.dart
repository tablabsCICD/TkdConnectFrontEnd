import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/registration_provider/user_details_provider.dart';
import 'package:tkd_connect/utils/phone_pay_payment.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';
import 'package:tkd_connect/widgets/sign_in_widget.dart';
import 'package:tkd_connect/widgets/textview.dart';
import '../../generated/l10n.dart';
import '../../utils/colors.dart';
import '../../utils/phone_pay_demo.dart';

class PersonalDetailsScreen extends StatefulWidget {
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
                        height: 60.h,
                      ),
                      AlredayAccountWidget()
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
    return Container(
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
                color: Color(0x4CB7B7B7),
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

}
