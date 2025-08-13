

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';
import 'package:tkd_connect/widgets/verified_tag.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/api_constant.dart';
import '../../constant/images.dart';
import '../../model/api_response.dart';
import '../../model/response/user_verified.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/editText.dart';
import '../bulkupload/load_upload.dart';
import '../kyc/kyc_screen_one.dart';
import 'package:http/http.dart' as http;


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MoreScreen();
  }

}
class _MoreScreen extends State<MoreScreen> {

  @override
  void initState() {
    super.initState();
    getLogin();
  }


  late User user;
  bool isLoad=true;

  getLogin()async{
    user=await LocalSharePreferences().getLoginData();
    isLoad=false;
    setState(() {

    });
  }

  callInsuranceApi(String enquiry) async {
    String url = ApiConstant.INSURANCE_API;
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": "I AM INTERESTED IN GETTING A GOOD DEAL FOR Insurance Inquiry.",
      "userId": user.content![0].id
    };
    ApiResponse response=await ApiHelper().postParameter(url, data);
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Insurance Enquiry submitted successfully!");
      Navigator.pop(context);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  callFinanceApi(String enquiry) async {
    String url = ApiConstant.FINANCE_API;
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": "I AM INTERESTED IN GETTING A GOOD DEAL FOR Finance Inquiry.",
      "userId": user.content![0].id
    };
    ApiResponse response=await ApiHelper().postParameter(url, data);
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Finance Enquiry submitted successfully!");
      Navigator.pop(context);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  callMParivahan() async {
    String url = ApiConstant.MPARIVAHAN;
    print(url);
    final response = await http.get(Uri.parse(url));

    print('The response status is ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if(jsonResponse['message']=="success"){
       // ToastMessage.show(context, jsonResponse['url']);
        debugPrint(jsonResponse['url']);
        Utils().callDynamicUrl(context,jsonResponse['url']);
      }else{
        ToastMessage.show(context, jsonResponse['message']+"Something went wrong!!");
      }
    //  Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  callTollCalculation() async {
    String url = ApiConstant.TOLL_CALCULATION;
    print(url);
    final response = await http.get(Uri.parse(url));

    print('The response status is ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if(jsonResponse['message']=="success"){
      //  ToastMessage.show(context, jsonResponse['url']);
        debugPrint(jsonResponse['url']);
        Utils().callDynamicUrl(context,jsonResponse['url']);
      }else{
        ToastMessage.show(context, jsonResponse['message']+"Something went wrong!!");
      }
      //Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoad?Container():SingleChildScrollView(
          child: Column(
            children: [
              topBar(context),
              item(S().myPost,(){
                Navigator.pushNamed(context, AppRoutes.mypost);

              },FontWeight.w600),
              item(S().bulkLoadUpload,(){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>BulkUploadLoad()));


              },FontWeight.w600),
              item(S().jobs,(){
                Navigator.pushNamed(context, AppRoutes.job);

              },FontWeight.w600),
              AppConstant.USERTYPE==AppConstant.TRANSPOTER || AppConstant.USERTYPE==AppConstant.AGENT?
              item(S().buySell,(){
                Navigator.pushNamed(context, AppRoutes.buysell);

              },FontWeight.w600):const SizedBox(),
              item(S().group,(){

                //RazorPayClass(context).initalPay(100,9503334903,"parag7kumbhar@gmail.com");
                Navigator.pushNamed(context, AppRoutes.group,arguments: user.content!.first.id);

              },FontWeight.w600),
              item(S().change_plan,(){

                //RazorPayClass(context).initalPay(100,9503334903,"parag7kumbhar@gmail.com");

                Navigator.pushNamed(context, AppRoutes.registration_plan_details);

              },FontWeight.w600),

              item(S().getVerified,(){

                openVerifiedTag();
              },FontWeight.w600),
               item(S().financeInquiry,(){
                 showInsuranceDialog(context,"Finance enquiry");
              },FontWeight.w600),
              item(S().insurance,(){
                showInsuranceDialog(context,"Insurance enquiry");
              },FontWeight.w600),
              item(S().tollCalculation,(){
                callTollCalculation();

              },FontWeight.w600),
              item(S().mParivahan,(){
                callMParivahan();

              },FontWeight.w600),
              item("Report Incident",(){
                Navigator.pushNamed(context, AppRoutes.reportIncidentList);
              },FontWeight.w600),
              item(S().appSetting,(){
                Navigator.pushNamed(context, AppRoutes.appsetting);
              },FontWeight.w400),
              item(S().helpSupport,(){
                Navigator.pushNamed(context, AppRoutes.helpsupport);

              },FontWeight.w400),

              item(S().shareapp,(){

                String meesage="Download TKD Connect now and use it to \n "
                    "We are here to elevate your logistics experience. Let us be your logistics assistance and your business needs will be fulfilled seamlessly. \n \n "
                "https://play.google.com/store/apps/details?id=com.pdk.tkd";
                Utils().callShareFunction(meesage);



              },FontWeight.w400),

              item(S().rateAndReviewApp,() async {
                Utils().requestReview(context);

              },FontWeight.w400),

              item(S().terms_condition,() async {
                Utils().callTermsAndCondition(context);

              },FontWeight.w400),

              item(S().privacyAndPolicy,() async {
                Utils().callPrivacyAndPolicy(context);

              },FontWeight.w400),

              itemLogout(S().logout,(){

                _showMyDialog();

              },)
            ],
          ),
        ),
      ),

    );
  }


  openVerifiedTag()async{
    int id=user.content!.first.id!;

    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.VERFIED_USER(id));
    if(apiResponse.status==200){
      VerifiedUser bidStateObj=VerifiedUser.fromJson(jsonDecode(apiResponse.response));
      if(bidStateObj.data==0){
        showBootomSheet(context);
      }else{
        ToastMessage.show(context, "You Already Verified");
      }

    }else{
    }


  }




  topBar(BuildContext context) {
    return Container(
        width: 375.w,
        height:  266.h ,
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        decoration: ShapeDecoration(
          color: ThemeColor.red,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            BaseWidget().getImageclip(user.content!.first.companyLogo!=null?user.content!.first.companyLogo!:"",width: 80.w,height: 112.h),
            selectedPlan(),
            nameWithVerfiyTag(),
            Text(
              user.content!.first.companyName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            SizedBox(height:6.h,),
            Text(
              user.content!.first.companyAddress!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(height:6.h,),
            button(context)
          ],
        ));
  }

  selectedPlan(){
    return  Container(
      transform: Matrix4.translationValues(0.0, -10.0.h, 0.0),
      // width: 36.w,
      // height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Utils().getSelectedPackageImage(user.content!.first.isPaid!),
            height: 8.h,
            width: 8.w,
          ),
          SizedBox(width: 4.w,),
          Text(
            Utils().getSelectedPackageName(user.content!.first.isPaid!),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8.sp,
              fontFamily: AppConstant.FONTFAMILY,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  nameWithVerfiyTag(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${user.content!.first.firstName!} ${user.content!.first.lastName!}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        SizedBox(width: 8.w,),
        Visibility(visible:user.content!.first.verified!=0?true:false,child: VerifiedTag().onVeriedTag())
      ],
    );
  }

  button(BuildContext context){
    return InkWell(
      onTap: ()async{
       var obj=await  Navigator.pushNamed(context, AppRoutes.editprofile);
          if(obj==1){
            getLogin();
          }
       },
      child: Container(
        width: 117.w,
        //height: 27.h,
        padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Colors.white),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S().editYourProfile,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  item(String  title,Function onClick,FontWeight fontWeight){
    return InkWell(
      onTap: (){
        onClick();
      },
      child: Container(
        width: 327.w,
        height: 60.h,
        decoration: const BoxDecoration(
          border: Border(

            bottom: BorderSide(width: 1, color: Color(0x192C363F)),
          ),
        ),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: fontWeight,

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Stack(children: [
                      SvgPicture.asset(Images.arrow_right)
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  itemLogout(String  title,Function onClick){
    return InkWell(
      onTap: (){
        onClick();
      },
      child: SizedBox(
        width: 327.w,
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const Stack(children: [
                    //  SvgPicture.asset(Images.arrow_right)
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showBootomSheet(BuildContext context) {

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(heightFactor:0.7,child: KYCScreenOne());
        });

  }


  Future<void> _showMyDialog ()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S().logout,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S().logoutMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S().yes,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () async{
                await LocalSharePreferences().logOut();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              },
            ),

            TextButton(
              child:  Text(S().no,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
}


  Future<void> showInsuranceDialog(BuildContext context, String enquiry) async {
    final TextEditingController _reasonController = TextEditingController();
    bool enable = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "I AM INTERESTED IN GETTING A GOOD DEAL FOR ${enquiry.toUpperCase()}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
             /* content: SizedBox(
                height: 130.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    Text(
                      enquiry+"(optional)",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                   *//* SizedBox(height: 16.h,),
                    EditText(
                      width: 335.w,
                      height: 52.h,
                      hint: enquiry,
                      controller: _reasonController,
                      onChange: (val) {
                        setState(() {
                          enable = val.isNotEmpty; // Enable button if text is entered
                        });
                      },
                    ),*//*
                  ],
                ),
              ),*/
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel',style: TextStyle(color: ThemeColor.red),),
                ),
                Button(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40.h,
                  title: S().submit,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  onClick: () {
                      if ("Insurance enquiry" == enquiry) {
                        callInsuranceApi(_reasonController.text);
                      } else {
                        callFinanceApi(_reasonController.text);
                      }
                  },
                  isEnbale: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

}