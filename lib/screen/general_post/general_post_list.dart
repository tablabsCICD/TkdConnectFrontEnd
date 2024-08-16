import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/general_post_model.dart';
import 'package:tkd_connect/model/response/job_list.dart';
import 'package:tkd_connect/provider/general_post/general_post_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';

class GeneralPostScreen extends StatefulWidget {
  const GeneralPostScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GeneralPostState();
  }
}

class _GeneralPostState extends State<GeneralPostScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GeneralPostProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                BaseWidget().appBarSearchFilter(context, S().jobs),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: Consumer<GeneralPostProvider>(
                    builder: (context, provider, child) {
                      return RefreshIndicator(
                        onRefresh: ()async{
                          provider.selectedPage=0;
                          provider.getAllPost();
                        },
                        child: ListView.builder(
                          controller: provider.scrollController,
                          itemCount: provider.generalPostList.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: 12.h, left: 20.w, right: 20.w),
                              child: getPostList(provider.generalPostList[i]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )),

    );
  }



  getPostList(GeneralPost generalPost) {
    return Container(
      width: 335.w,
      // height: 417.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0.r),
          ),
          elevation: 1,
          child: Container(
            height: 100.h,
            // width: 510.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r)
            ),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  //leading: getImage("${generalPost.images==[]?'':generalPost.images![0]}"),
                  title: Text(
                    "${generalPost.title}",
                   style: TextStyle(
                     fontSize:15.sp,
                     fontWeight: FontWeight.w600,
                     color: const Color(0xff000000),
                   ),
                  ),
                  subtitle: Text(
                    "${generalPost.description}",
                    style: TextStyle(
                      fontSize:15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff818080),
                    ),
                  ),
                ),
                SizedBox(height: 16.h,),
                const Divider(),
                SizedBox(height: 16.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Images.like),
                        const SizedBox(width: 5),
                        Text(
                          S().like,
                          style: TextStyle(
                            color: const Color(0xFF001E49),
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '0',
                          style: TextStyle(
                            color: const Color(0xFF001E49),
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Images.message),
                        const SizedBox(width: 5),
                        Text(
                          S().comment,
                          style: TextStyle(
                            color: const Color(0xFF001E49),
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '0',
                          style: TextStyle(
                            color: const Color(0xFF001E49),
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                )
                // BaseWidget().likeComment(),
              ],
            ),
          )),
    );
  }

  Widget jobApply(JobData jobData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              Utils().callFunction(jobData.postJob!.contactNumber.toString());
            },
            child: Container(
              height: 38.h,
              //width: 203.w,//for save job
              width: 240.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: const Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Call now',
                    style: TextStyle(
                      color: const Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  SizedBox(width: 12.w),
          // SvgPicture.asset(Images.savejob),
          SizedBox(width: 12.w),
          InkWell(
              onTap: (){
                String Message="I am writing to express my strong interest in the ${jobData.postJob!.jobDepartment!} From TKD Connect Application";
                Utils().openwhatsapp(context, jobData.postJob!.contactNumber!, Message);
              },
              child: SvgPicture.asset(Images.message_job)),
        ],
      ),
    );
  }
}
