import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../generated/l10n.dart';
import '../../provider/help_support/help_support_provider.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HelpSupportProvider(""),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseWidget().appBar(context, S().helpSupport),
              Container(
                height: 20.h,
                color: ThemeColor.baground,
              ),

              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    titleText(S().email_id),
                    SizedBox(
                      height: 2.h,
                    ),
                    subTitle('support@tkdconnect.in'),
                    SizedBox(
                      height: 8.h,
                    ),

                    titleText(S().traffic),
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
                        Text(" / "),
                        InkWell(

                          onTap: (){
                            Utils().callFunction("8123004666");
                          },child:   subTitle('(+91)  8123004666 '),
                        ),
                     ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),

                    titleText(S().website),
                    SizedBox(
                      height: 2.h,
                    ),
                    subTitle('www.tkdconnect.in'),
                    SizedBox(
                      height: 20.h,
                    ),
                    orView(),
                    SizedBox(
                      height: 20.h,
                    ),

                    titleText(S().raiseATicket),
                    SizedBox(
                      height: 5.h,
                    ),
                    // dropList(context),
                    Consumer<HelpSupportProvider>(
                      builder: (context, provider, child) {
                        return popUpmenu(
                                (val) => () {
                              provider.changeDropDown(val);
                            },
                            context);
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    editTextBox(context),
                    SizedBox(
                      height: 5.h,
                    ),
                    Consumer<HelpSupportProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.remaningText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<HelpSupportProvider>(
        builder: (context, provider, child) {
          return Button(
              width: 335.w,
              height: 52.h,
              title: S().submit,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              isEnbale: provider.enableButton,
              onClick: () {
                provider.sumbitTicket(context);
              });
        },
      ),
    );
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
        color: Color(0xFFC3262C),
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
      decoration: ShapeDecoration(
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

  orView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        drwaLine(),
        SizedBox(
          width: 20.w,
        ),
        Text(
          S().OR,
          style: TextStyle(
            color: Color(0x99001E49),
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        drwaLine(),
      ],
    );
  }

  dropList(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                provider.dropValue,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 24,
                            height: 24,
                            child: Stack(children: [
                              SvgPicture.asset(Images.dwon_arrow)
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  editTextBox(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 145.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0x332C363F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: TextField(
                                  controller: provider.textEditingController,
                                  onChanged: (value) {
                                    provider.countText();
                                  },
                                  maxLines: 5,
                                  maxLength: 300,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      counter: Offstage(),
                                      hintText: S().explainYourConcern,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0x662C363F),
                                        fontSize: 14.sp,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  popUpmenu(Function(String) onMenuTap, BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton(
          position: PopupMenuPosition.values[1],
          constraints:
              BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: dropList(context)),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                provider.changeDropDown(S().createPostLoadIssue);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      S().createPostLoadIssue,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown(S().appCrash);
                },
                child: Row(
                  children: [
                    Text(
                      S().appCrash,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown(S().createJobPost);
                },
                child: Row(
                  children: [
                    Text(
                      S().createJobPost,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown(S().buysellIssue);
                },
                child: Row(
                  children: [
                    Text(
                      S().buysellIssue,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
