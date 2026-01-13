import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/plan/select_plan.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../utils/razor_pay.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/utils.dart';
import '../../widgets/button.dart';
import '../../widgets/plan_widget.dart';
import '../../widgets/textview.dart';

class SelectPlanScreen extends StatefulWidget {
  const SelectPlanScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SelectPlanScreen();
  }
}

class _SelectPlanScreen extends State<SelectPlanScreen> {
  int userType=-1;
  @override
  void initState() {
    // TODO: implement initState
    checkUserType();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SelectPlanProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

 _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Consumer<SelectPlanProvider>(
          builder: (context, provider, child) {
            return Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child:/*userType==3?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 21.5.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:  SvgPicture.asset(Images.arrow_back),
                      ),
                      Textview(
                        title: 'Upgrade Plan',
                        TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: 21.h,
                  ),

                  Textview(
                    title: 'For Upgrade Plan Please Connect to the below Contact ',
                    TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  titleText(S().email_id),
                  SizedBox(
                    height: 5.h,
                  ),
                  subTitle('support@tkdconnect.in'),
                  SizedBox(
                    height: 20.h,
                  ),
                  titleText(S().mobileNumber),
                  SizedBox(
                    height: 2.h,
                  ),
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

                ],

              ):*/
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 21.5.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   InkWell(
                     onTap: (){
                       Navigator.pop(context);
                     },
              child:  SvgPicture.asset(Images.arrow_back),
                   ),
                    Textview(
                      title: 'Upgrade Plan',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox()
                  ],
                ),
                SizedBox(
                  height: 21.h,
                ),
               // LinearProgressBar(fillValue: 301.w),
                SizedBox(
                  height: 21.h,
                ),
                InkWell(
                    onTap: () {
                     provider.selectClearPerl();
                    },
                    child: PlanWidget(
                      isSelected: provider.clearPearl,
                      title: 'Clear pearl',
                      amount: '0',
                      image: Images.pearls,
                      subtitle: 'CURRENT PLAN',
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 5 Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 1 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Only 5 Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          false,
                          false,
                          false,
                          true,
                          true,
                          true,
                          false,
                          true,
                          false,
                          false,
                          false,
                          false
                        ];
                        provider.onDeatilsPlan(context,listLaugaes, selectLang, Images.pearls,
                            "Clear pearl", "0");
                      },
                    )),
                SizedBox(
                  height: 12.h,
                ),
                InkWell(
                    onTap: () {
                     provider.selectBlue();
                    },
                    child: PlanWidget(
                      isSelected:provider. bluePearl,
                      title: 'Blue pearl',
                      amount: '2000/Month',
                      image: Images.pearls_blue,
                      subtitle: 'RECOMMENDED',
                      onClick: () {
                        List<String> listLaugaes = [
                          "View Unlimited Client Loads",
                          'Post Unlimited Loads',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Add your Company website Link with Visiting Card',
                          'One month Color Advertisement Complimentary',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true
                        ];
                        provider. onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_blue, "Blue pearl", "2000/Month");
                      },
                    )),
                SizedBox(
                  height: 12.h,
                ),
                InkWell(
                    onTap: () {
                     provider.selectRed();
                    },
                    child: PlanWidget(
                      isSelected: provider.redPearl,
                      title: 'Red pearl',
                      amount: '2500/Half Year',
                      image: Images.pearls_red,
                      subtitle: provider.selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "View Unlimited Client Loads / Transporters Loads ",
                          'Post Unlimited Loads',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Add your Company website Link with Visiting Card',
                          'Six Month Color Advertisement Complimentary',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true
                        ];

                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_red, "Red pearl", "2500/Half Year");
                      },
                    )),
                SizedBox(
                  height: 12.h,
                ),
                InkWell(
                    onTap: () {
                     provider.selectBlack();
                    },
                    child: PlanWidget(
                      isSelected:provider. blackPearl,
                      title: 'Black pearl',
                      amount: '5000/Annual',
                      image: Images.pearls_black,
                      subtitle:provider. selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "View Unlimited Client Loads / Transporters Loads ",
                          'Post Unlimited Loads',
                          'SMS Notifications',
                          'Get More Loads with Verified Listing  '
                          'WHATSAPP Notifications',
                          'Add your Company website Link with Visiting Card',
                          'Be top on Search In Transport Directory.',
                          'JOB POSTING',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true
                        ];
                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_black, "Black pearl", "5000/Annual");
                      },
                    )),
                SizedBox(
                  height: 161.h,
                ),
                Button(
                    width: 335.w,
                    height: 49.h,
                    title: "Next",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                    onClick: () {
                      if(provider.previousPlan==provider.selectedPlanCode){
                        print("already in bottom sheet");
                        ToastMessage.show(context, "You have already this plan");
                      }else{
                        if (provider.planAmount == 0) {
                          provider.selectedPlan(context);
                        } else {
                          startTran(provider);
                        }
                      }
                    }
                    ),

              ]),
            );
          },
        ),
      ),
    );
  }
  startTran(SelectPlanProvider provider) async {
    User user=await LocalSharePreferences().getLoginData();
    print("in bottom sheet");
    RazorPayClass(context).initalPay(provider.planAmount,user.content!.first.mobileNumber!,user.content!.first.emailId!,provider.selectPlan,provider.selectedPlanCode);
  }

  void checkUserType() async{

    User user=await LocalSharePreferences().getLoginData();
   userType= user.content!.first.transporterOrAgent!;
   setState(() {

   });

    // if(user.content!.first.transporterOrAgent==3){
    //
    // }

  }


  titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  subTitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        color: const Color(0xFFC3262C),
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  drwaLine() {
    return Container(
      width: 89.w,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x332C363F),
          ),
        ),
      ),
    );
  }

}
