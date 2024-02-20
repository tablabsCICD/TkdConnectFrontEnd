import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/plan/select_plan.dart';
import 'package:tkd_connect/screen/kyc/kyc_screen_one.dart';
import 'package:tkd_connect/screen/plan/plan_details_screen.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/phone_pay_payment.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/linear_progress.dart';
import 'package:tkd_connect/widgets/sign_in_widget.dart';

import '../../constant/images.dart';
import '../../widgets/button.dart';
import '../../widgets/plan_widget.dart';
import '../../widgets/textview.dart';

class SelectPlanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectPlanScreen();
  }
}

class _SelectPlanScreen extends State<SelectPlanScreen> {
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 21.5.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(Images.arrow_back),
                    Textview(
                      title: 'Select Plan',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox()
                  ],
                ),
                SizedBox(
                  height: 21.h,
                ),
                LinearProgressBar(fillValue: 301.w),
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
                      amount: '299',
                      image: Images.pearls_blue,
                      subtitle: 'RECOMMENDED',
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 50)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST Only(5)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING Only (50)',
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
                        provider. onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_blue, "Blue pearl", "299");
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
                      amount: '349',
                      image: Images.pearls_red,
                      subtitle: provider.selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 100 Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 10 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Only 100 Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
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

                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_red, "Red pearl", "349");
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
                      amount: '449',
                      image: Images.pearls_black,
                      subtitle:provider. selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Unlimited Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 20 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Unlimited Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
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
                          true,
                          true,
                          true,
                          true
                        ];
                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_black, "Black pearl", "449");
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
                      //showBootomSheet();
                      if(provider.previousPlan==provider.selectedPlanCode){
                        ToastMessage.show(context, "You have already this plan");
                      }else{
                        if (provider.planAmount == 0) {
                          provider.goHome(context);
                        } else {
                          //provider.selectedPlan(context);
                         // print('verfiy data string ${PhonePayPayment().getSaltVerfy(100)}');

                          startTran(provider);
                        }
                      }

                    }),
                // SizedBox(height: 60.h,),
                // AlredayAccountWidget()
              ]),
            );
          },
        ),
      ),
    );
  }



  startTran(SelectPlanProvider provider) async {

    // await PhonePayPayment().getTranscation();
    // if(AppConstant.PHONE_PAY_TRANSCATION_ID==""){
    //   ToastMessage.show(context, "Please Try Again");
    //   return null;
    // }
    await PhonePayPayment().getTranscation();

    bool init = await PhonePayPayment().initPhonePay();
    if (init) {
      await PhonePePaymentSdk.startTransaction(
              PhonePayPayment().getBody(provider.planAmount),
              '',
              PhonePayPayment().getSalt(provider.planAmount),
              PhonePayPayment().packageName)
          .then((response) => {
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      // "Flow Completed - Status: Success!";

                      PhonePayPayment().getStatusOfTranscation();
                     // provider.selectedPlan(context);

                      print('the response is $response');
                    } else {
                      // "Flow Completed - Status: $status and Error: $error";
                    }
                  } else {
                    // "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        print('${error}');
        return <dynamic>{};
      });
    } else {
      ToastMessage.show(context,
          "Please Try Again or select free plan and then update now payment is not accepting");
    }
  }


}
