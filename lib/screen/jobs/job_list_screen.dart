import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
import '../../widgets/common_app_bar.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  static String formatExperience(String? raw) {
    if (raw == null) return "Exp: Not Specified";
    String text = raw.trim();
    if (text.isEmpty ||
        text.toLowerCase() == "null" ||
        text.toLowerCase() == "no info" ||
        text.toLowerCase() == "na" ||
        text.toLowerCase() == "n/a" ||
        text.toLowerCase() == "none") {
      return "Exp: Not Specified";
    }

    // Strip existing prefix if present to standardize
    if (text.toLowerCase().startsWith("exp:")) {
      text = text.substring("exp:".length).trim();
    } else if (text.toLowerCase().startsWith("exp:")) {
      text = text.substring("exp:".length).trim();
    }

    if (text.toLowerCase() == "fresher") {
      return "Exp: Fresher";
    }

    // Normalize dashes and hyphens
    text = text.replaceAll("–", "-").replaceAll("—", "-");

    // Check for range patterns: e.g. "0 - 2", "1 Year - 1.5 Year", "Fresher - 1 Year"
    if (text.contains("-")) {
      List<String> parts = text.split("-").map((p) => p.trim()).toList();
      if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        String from = parts[0];
        String to = parts[1];

        String cleanFrom = from
            .replaceAll(
                RegExp(r'\s*(years?|yrs?)\.?\s*$', caseSensitive: false), '')
            .trim();
        String cleanTo = to
            .replaceAll(
                RegExp(r'\s*(years?|yrs?)\.?\s*$', caseSensitive: false), '')
            .trim();

        if (cleanFrom.toLowerCase() == "fresher") {
          return "Exp: Fresher–$cleanTo ${cleanTo == '1' ? 'Year' : 'Years'}";
        }

        if (cleanFrom == cleanTo) {
          return "Exp: $cleanFrom ${cleanFrom == '1' ? 'Year' : 'Years'}";
        }

        String unit = (cleanTo == '1' && cleanFrom == '0') ? 'Year' : 'Years';
        return "Exp: $cleanFrom–$cleanTo $unit";
      }
    }

    // Single value with + (e.g. "5+", "5+ Years")
    String cleaned = text
        .replaceAll(
            RegExp(r'\s*(years?|yrs?)\.?\s*$', caseSensitive: false), '')
        .trim();

    if (cleaned.endsWith("+")) {
      return "Exp: $cleaned Years";
    }

    // Numeric single value (e.g. "2", "1")
    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(cleaned)) {
      return "Exp: $cleaned ${cleaned == '1' ? 'Year' : 'Years'}";
    }

    // Custom non-standard text: ensure "Experience: " prefix and proper suffix
    if (!text.toLowerCase().contains("year") &&
        !text.toLowerCase().contains("fresher")) {
      return "Experience: $text Years";
    }

    return "Experience: $text";
  }

  @override
  State<JobListScreen> createState() => _JobListState();
}

class _JobListState extends State<JobListScreen> {
  List<String> expList = [
    "Fresher",
    "6 Month",
    "1 Year",
    "1.5 Year",
    "2 Year",
    "2.5 Year",
    "3 Year",
    "3.5 Year",
    "4 Year",
    "4.5  Year",
    "5 Year",
    "5.5 Year",
    "6 Year"
  ];
  List<String> salaryList = [
    '1LPA',
    '1PLA to 2LPA',
    '2PLA to 3LPA',
    '4PLA to 5LPA',
    '6PLA to 7LPA',
    '8PLA to 9LPA',
    '10PLA to Above',
  ];

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
                      padding: EdgeInsets.only(bottom: 60.h),
                      itemCount: provider.listJobs.length,
                      itemBuilder: (context, i) {
                        final jobData = provider.listJobs[i];
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer<JobListProvider>(
          builder: (context, provider, child) {
            return Visibility(
              visible: true,
              child: InkWell(
                onTap: () async {
                  User use = await LocalSharePreferences().getLoginData();
                  if (use.content != null &&
                      use.content!.isNotEmpty &&
                      use.content!.first.isPaid != 0) {
                    if (!context.mounted) return;
                    Object? val =
                        await Navigator.pushNamed(context, AppRoutes.createjob);
                    if (val != null) {
                      provider.selectedPage = 0;
                      provider.getAllJobs();
                      if (provider.scrollController.hasClients) {
                        provider.scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                  } else {
                    if (!context.mounted) return;
                    Navigator.pushNamed(
                        context, AppRoutes.registration_plan_details);
                  }
                },
                child: Container(
                  width: 155.w,
                  height: 38.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
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
      ),
    );
  }

  jobCard(JobData jobData) {
    return Container(
      width: 335.w,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: ShapeDecoration(
                color: const Color(0xFFD25D5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              child: Text(
                JobListScreen.formatExperience(jobData.postJob?.experience),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          BaseWidget().profileWithUser(
            "",
            jobData.name ?? "No Info",
            jobData.postJob?.companyName ?? "No Info",
            verify: jobData.isVerified ?? 1,
            transporterOrAgent: jobData.transporterOrAgent ?? 1,
            ratings: 4.5,
            isJob: true,
            email: jobData.postJob?.emailId ?? "",
          ),
          BaseWidget().jobHeading(jobData.postJob?.salary ?? "Not Disclosed"),
          BaseWidget().heading(
            jobData.postJob?.jobDepartment ?? "",
            jobData.postingDate == null
                ? ""
                : jobData.postingDate!.split(" ").first,
            jobData.postJob?.jobDescription ?? "",
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                  Text("Department",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  TextField(
                    controller: provider.departmentController,
                    decoration: _filterInput("Enter department"),
                    onChanged: (v) => provider.selectedDepartment = v,
                  ),

                  SizedBox(height: 14),

                  // ✅ EXPERIENCE
                  Text("Experience",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  DropdownButtonFormField(
                    initialValue: provider.selectedExperience,
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
                    initialValue: provider.selectedSalary,
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
                  Text("Posting Date",
                      style: TextStyle(fontWeight: FontWeight.w600)),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
