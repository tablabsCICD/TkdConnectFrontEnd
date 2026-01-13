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
  // << ADDED

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/textview.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListState();
}

class _JobListState extends State<JobListScreen> {

  List<String> expList = ["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"];
  List<String> salaryList = ['1LPA','1PLA to 2LPA','2PLA to 3LPA','4PLA to 5LPA','6PLA to 7LPA','8PLA to 9LPA','10PLA to Above',];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobListProvider(),
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        body: Column(
          children: [

            // ✅ APP BAR
            Consumer<JobListProvider>(
              builder: (context, provider, _) {
                return CommonAppBar(
                  title: "Jobs",
                  isTitle: true,
                  isBack: true,
                  isSearchBar: true,
                  isFilter: true,
                  searchController: provider.searchQuery,
                  onBackTap: () => Navigator.pop(context),
                  onSearchChanged: (value) => provider.getBySearchData(),
                  onFilterTap: () => _openFilters(context),
                );
              },
            ),

            SizedBox(height: 30),

            // ✅ JOB LIST
            Expanded(
              child: Consumer<JobListProvider>(
                builder: (context, provider, _) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      provider.selectedPage = 0;
                      provider.getAllJobs();
                    },
                    child: ListView.builder(
                      controller: provider.scrollController,
                      itemCount: provider.listJobs.length,
                      itemBuilder: (context, i) {
                        final jobData = provider.listJobs[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: jobCard(jobData),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  jobCard(JobData jobData) {
    return Container(
      width: 335.w,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        shadows: [
          BoxShadow(
            color: const Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
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
                  jobData.postJob?.experience != null
                      ? "Exp: ${jobData.postJob!.experience} Year"
                      : "No Info",
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                ),
              ),
            ),
          ),

          BaseWidget().profileWithUser(
            "",
            jobData.name ?? "No Info",
            jobData.postJob?.companyName ?? "No Info",
            verify: jobData.isVerified ?? 1,
            transporterOrAgent: jobData.transporterOrAgent ?? 1,
            ratings: 4.5,
            isJob: true,
            email: jobData.postJob!.emailId??""
          ),

          BaseWidget().jobHeading(jobData.postJob!.salary!),

          BaseWidget().heading(
            jobData.postJob!.jobDepartment!,
            jobData.postingDate == null
                ? ""
                : jobData.postingDate!.split(" ").first,
            jobData.postJob!.jobDescription!,
          ),

          jobApply(jobData),
        ],
      ),
    );
  }

  Widget jobApply(JobData jobData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Utils().callFunction(jobData.postJob!.contactNumber.toString());
          },
          child: Container(
            height: 38.h,
            width: 240.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0x33001E49)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                "Call Now",
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            String msg =
                "I am writing to express my strong interest in the ${jobData.postJob!.jobDepartment!} From TKD Connect Application";
            Utils().openwhatsapp(
              context,
              jobData.postJob!.contactNumber!,
              msg,
            );
          },
          child: SvgPicture.asset(Images.message_job),
        ),
      ],
    );
  }


  void _openFilters(BuildContext context) {
    final provider = context.read<JobListProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ✅ HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Jobs",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  Divider(),

                  // ✅ ROLE
                  Text("Role", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextField(
                    controller: provider.roleController,
                    decoration: _filterInput("Enter role"),
                    onChanged: (v) => provider.selectedRole = v,
                  ),

                  SizedBox(height: 14),

                  // ✅ DEPARTMENT
                  Text("Department", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextField(
                    controller: provider.departmentController,
                    decoration: _filterInput("Enter department"),
                    onChanged: (v) => provider.selectedDepartment = v,
                  ),

                  SizedBox(height: 14),

                  // ✅ EXPERIENCE
                  Text("Experience", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  DropdownButtonFormField(
                    value: provider.selectedExperience,
                    decoration: _filterInput("Select experience"),
                    items: expList
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (v) {
                      setStateSB(() => provider.selectedExperience = v);
                    },
                  ),

                  SizedBox(height: 14),

                  // ✅ SALARY
                  Text("Salary", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  DropdownButtonFormField(
                    value: provider.selectedSalary,
                    decoration: _filterInput("Select salary"),
                    items: salaryList
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (v) {
                      setStateSB(() => provider.selectedSalary = v);
                    },
                  ),

                  SizedBox(height: 14),

                  // ✅ DATE
                  Text("Posting Date", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );

                      if (picked != null) {
                        setStateSB(() => provider.selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, size: 18),
                          SizedBox(width: 10),
                          Text(
                            provider.selectedDate == null
                                ? "Select date"
                                : provider.selectedDate
                                .toString()
                                .split(" ")
                                .first,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ✅ BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      TextButton(
                        onPressed: () {
                          provider.clearFilters();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          provider.applyFilters();
                          Navigator.pop(context);
                        },
                        child: Text("Apply"),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  InputDecoration _filterInput(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeColor.theme_blue),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

}
