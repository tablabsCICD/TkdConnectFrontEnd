import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/jobs/create_job_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/common_app_bar.dart';

import '../../generated/l10n.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/editText.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreateJobProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ThemeColor.white,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              CommonAppBar(
                title: S().postJob,
                isBack: true,
                isTitle: true,
                isSearchBar: false,
                isFilter: false,
                onBackTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500.w),
                      child: Consumer<CreateJobProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelText(S().position),
                              SizedBox(height: 6.h),
                              editView(
                                S().egSeniorManager,
                                provider.positionController,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 16.h),

                              labelText(S().jobTitle),
                              SizedBox(height: 6.h),
                              editView(
                                S().egManageInquiries,
                                provider.JobTitileController,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 16.h),

                              labelText(S().salary),
                              SizedBox(height: 6.h),
                              DropDown(
                                width: double.infinity,
                                onClick: () async {
                                  FocusScope.of(context).unfocus();
                                  ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                                  int a = await itemBottomSheet.showIteam(
                                      context, provider.salary, provider.selectSal);
                                  provider.selectedJob(a);
                                },
                                hint: provider.selectSal,
                              ),
                              SizedBox(height: 16.h),

                              labelText(S().jobDes),
                              SizedBox(height: 6.h),
                              editViewDiscription(
                                S().egJobDes,
                                context,
                                provider.descriptionController,
                                provider,
                              ),
                              SizedBox(height: 16.h),

                              labelText(S().specifyRequiredExperience),
                              SizedBox(height: 6.h),
                              jobExp(context),
                              SizedBox(height: 24.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Submit button pinned at bottom of body Column:
              // With resizeToAvoidBottomInset: true, it automatically and smoothly
              // adjusts directly above the mobile keyboard when the keyboard opens,
              // keeping it accessible at all times without overlapping.
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: Consumer<CreateJobProvider>(
                  builder: (context, provider, child) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500.w),
                        child: Button(
                          isEnbale: provider.buttonActive && !provider.isSubmitting,
                          width: double.infinity,
                          height: 48.h,
                          title: provider.isSubmitting
                              ? "Submitting..."
                              : S().createJobPost,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                          onClick: () {
                            FocusScope.of(context).unfocus();
                            provider.onSubitJobPost(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  labelText(String label) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  editView(String hint, TextEditingController controller,
      {TextInputAction? textInputAction, Function(String)? onSubmitted}) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return EditText(
          width: double.infinity,
          height: 52.h,
          hint: hint,
          controller: controller,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          onChange: (val) {
            provider.buttonEnble();
          },
        );
      },
    );
  }

  editViewDiscription(String hint, BuildContext context,
      TextEditingController controller, CreateJobProvider provider) {
    return Container(
      width: double.infinity,
      height: 124.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          provider.buttonEnble();
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        maxLines: 4,
        maxLength: 300,
        obscureText: false,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          counter: const Offstage(),
          hintText: hint,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(
            color: const Color(0x662C363F),
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  jobExp(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            provider.showExpDialog(context);
          },
          child: Container(
            width: double.infinity,
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: ShapeDecoration(
              color: provider.expUpdate ? Colors.white : const Color(0x0A2C363F),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x332C363F)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    provider.expFrom,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xCC001E49),
                      fontSize: 14.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xCC001E49),
                      fontSize: 14.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    provider.expTo,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xCC001E49),
                      fontSize: 14.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
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
