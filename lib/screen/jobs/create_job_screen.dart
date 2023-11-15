import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/jobs/create_job_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../generated/l10n.dart';
import '../../widgets/editText.dart';
import 'experience_screen.dart';

class CreateJobScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreateJobProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
        color: ThemeColor.white,
        child: Column(
            children: [
              BaseWidget().appBar(context, S().postJob),
              Container(
                height: 20.h,
                color: ThemeColor.baground,
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<CreateJobProvider>(
                builder: (context, provider, child) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        labelText(S().position),
                        SizedBox(
                          height: 4,
                        ),
                        editView(S().egSeniorManager,
                            provider.positionController),
                        SizedBox(
                          height: 12,
                        ),
                        labelText(S().jobTitle),
                        SizedBox(
                          height: 4,
                        ),
                        editView(
                            S().egManageInquiries, provider.JobTitileController),
                        SizedBox(
                          height: 12,
                        ),


                        labelText(S().salary),
                        SizedBox(
                          height: 4,
                        ),
                        editView(
                            S().egSal, provider.salController),
                        SizedBox(
                          height: 12,
                        ),



                        labelText(S().jobDes),
                        SizedBox(
                          height: 4,
                        ),
                        editViewDiscription(S().egJobDes, context,
                            provider.descriptionController),
                        SizedBox(
                          height: 12,
                        ),

                        labelText(S().specifyRequiredExperience),
                        SizedBox(
                          height: 4,
                        ),
                        jobExp(context),
                      ],
                    ),
                  );
                },
              )
            ],
        ),
      ),
          )),
      bottomNavigationBar: Consumer<CreateJobProvider>(
  builder: (context, provider, child) {
  return Button(
          isEnbale: provider.buttonActive,
          width: 335.h,
          height: 48.h,
          title: S().createJobPost,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
          onClick: () {
            provider.onSubitJobPost(context);

          });
  },
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

  editView(String hint, TextEditingController controller) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return EditText(
          width: 335.w,
          height: 52.h,
          hint: hint,
          controller: controller,
          onChange: (val) {
            provider.buttonEnble();
          },
        );
      },
    );
  }

  editViewDiscription(
      String hint, BuildContext context, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 124.h,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
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
                              controller: controller,
                              onChanged: (value) {
                                // provider.countText();
                              },
                              maxLines: 3,
                              maxLength: 300,
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  counter: Offstage(),
                                  hintText: hint,
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
                                fontFamily: GoogleFonts.poppins().fontFamily,
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
  }

  jobExp(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () async {
            provider.showExpDialog(context);
          },
          child: Container(
            width: 335,
            height: 37.65,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: ShapeDecoration(
              color: provider.expUpdate ? Colors.white : Color(0x0A2C363F),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x332C363F)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      provider.expFrom,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '-',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC001E49),
                    fontSize: 12.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w800,
                    height: 0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      provider.expTo,
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
