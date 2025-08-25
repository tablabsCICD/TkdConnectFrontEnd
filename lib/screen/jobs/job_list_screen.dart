import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/job_list.dart';
import 'package:tkd_connect/provider/jobs/job_list_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JobListState();
  }
}

class _JobListState extends State<JobListScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => JobListProvider(),
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
            searchBoxFilter(),            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Consumer<JobListProvider>(
                builder: (context, provider, child) {
                  return RefreshIndicator(
                    onRefresh: ()async{
                      provider.selectedPage=0;
                      provider.getAllJobs();
                    },
                    child: ListView.builder(
                      controller: provider.scrollController,
                      itemCount: provider.listJobs.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 12.h, left: 20.w, right: 20.w),
                          child: jobCard(provider.listJobs[i]),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<JobListProvider>(
        builder: (context, provider, child) {
          return Visibility(
            visible: true,
            child: InkWell(
              onTap: () async {
                User use=await LocalSharePreferences().getLoginData();
                if(use.content!.first.isPaid!=0){
                  Object? val =
                  await Navigator.pushNamed(context, AppRoutes.createjob);
                  if (val != null) {
                    provider.selectedPage = 0;
                    provider.getAllJobs();
                  }

                }else{


                  Navigator.pushNamed(context, AppRoutes.registration_plan_details);

                }
             },
              child: Container(
                width: 155.w,
                height: 38.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: ThemeColor.theme_blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().postAJob,
                      style: TextStyle(
                        color: ThemeColor.progress_color,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: Stack(children: [
                              SvgPicture.asset(
                                Images.add,
                                height: 16.h,
                                width: 16.w,
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  searchBoxFilter() {
    return Consumer<JobListProvider>(
      builder: (context, provider, child) {
        return Container(
         // width: 300.w,
          height: 52.h,

          margin: const EdgeInsets.fromLTRB(20,16,20,0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                margin: EdgeInsets.only(left: 10.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Stack(children: [
                        SvgPicture.asset(Images.search_normal)
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: provider.searchQuery,
                    onChanged: (value) {
                      provider.getBySearchData();
                    },
                    decoration: InputDecoration(
                        hintText: "Search by user,salary,experience",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: const Color(0x662C363F),
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
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
        );
      },
    );
  }

  jobCard(JobData jobData) {
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
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 70.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: const Color(0xFFD25D5D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  jobData.postJob!.experience != null
                      ? "Exp: ${jobData.postJob!.experience!} Year"
                      : "No Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          BaseWidget().profileWithUser(
              "",
              jobData.name != null ? jobData.name! : "No Info",
              jobData.postJob!.companyName != null
                  ? jobData.postJob!.companyName!
                  : "No Info",verify: jobData.isVerified??1,transporterOrAgent: jobData.transporterOrAgent??1),
          SizedBox(width: 8.w),
          BaseWidget().jobHeading(jobData.postJob!.salary!),
          BaseWidget().heading(
              jobData.postJob!.jobDepartment!,
              jobData.postingDate != null ? jobData.postingDate!.split(" ").first : "",
              jobData.postJob!.jobDescription!),
          SizedBox(width: 8.w),
          jobApply(jobData),
        ],
      ),
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
