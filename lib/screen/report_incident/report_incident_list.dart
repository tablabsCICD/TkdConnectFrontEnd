
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/getAllReportIncidentResponse.dart';
import 'package:tkd_connect/provider/incident/report_incident_provider.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../widgets/card/base_widgets.dart';

class ReportIncidentList extends StatefulWidget {
  const ReportIncidentList({super.key});

  @override
  State<ReportIncidentList> createState() => _ReportIncidentListState();
}

class _ReportIncidentListState extends State<ReportIncidentList> {


    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (BuildContext context) => ReportIncidentProvider(),
        builder: (context, child) => _buildPage(context),
      );
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getUser();
    }
    User? user;

    getUser() async {
      user =
      await LocalSharePreferences.localSharePreferences.getLoginData();
    }

    _buildPage(BuildContext context) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: true,
          child: InkWell(
            onTap: () async {
              await Navigator.pushNamed(context, AppRoutes.reportIncident);
            },
            child: Container(
              width: 180.w,
              height: 38.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: ThemeColor.theme_blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                "Report Your Incident",
                style: TextStyle(
                  color: ThemeColor.progress_color,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        body: Consumer<ReportIncidentProvider>(
          builder: (context, provider, child) {
            return Container(
              color: ThemeColor.baground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  top_bar(context, provider),
                  SizedBox(
                    height: 35.h,
                  ),
                  allReportTag(provider),
                  provider.allReport.isEmpty && provider.isLoadDone
                      ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(S().noRecordFound),
                      ))
                      : const SizedBox.shrink(),
                  getReportList()
                ],
              ),
            );
          },
        ),
      );
    }

    Widget allReportTag(ReportIncidentProvider provider) {
      return Container(
        margin: EdgeInsets.only(left: 20.w, top: 0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              backgroundColor: Colors.transparent,
              selectedColor: ThemeColor.theme_blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: ThemeColor.theme_blue,
                ),
              ),
              label: Text(
                "All Incident",
                style: TextStyle(
                  color: !provider.myIncident ? Colors.white : Colors.black,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              selected: !provider.myIncident,
              onSelected: (_) => provider.toggleMyNews(false),
            ),
            ChoiceChip(
              backgroundColor: Colors.transparent,
              selectedColor: ThemeColor.theme_blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: ThemeColor.theme_blue,
                ),
              ),
              label: Text(
                "My Incident",
                style: TextStyle(
                  color: provider.myIncident ? Colors.white : Colors.black,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              selected: provider.myIncident,
              onSelected: (_) => provider.toggleMyNews(true),
            ),
          ],
        ),
      );
    }

    Widget getReportList() {
      return Consumer<ReportIncidentProvider>(
        builder: (context, provider, child) {
          return Expanded(
            child: ListView.builder(
              itemCount: provider.allReport.length,
              itemBuilder: (context, index) {
                final query = provider.allReport[index];
                DateTime date = DateTime.fromMillisecondsSinceEpoch(query.date??1747293525000);

                // Format the DateTime to a readable string
                String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _displayDetails(context,query,provider);
                      },
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          query.image != null
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BaseWidget().image(image: query.image!),
                              )
                              : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text("Incident Type: ${ query.incidentType ?? "Unknown Incident"}"
                           ,
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 13.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Cheated By: ${ query.cheatedBy ?? "Cheater: N/A"}"
                            ,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Amount Lost: ${query.amountLost ?? "N/A"}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Date: ${formattedDate.toString() ?? "N/A"}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            "FIR Launched: ${query.isFirLounched == true ? "Yes" : "No"}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            query.resolutionDetails ?? "Resolution Details: N/A",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
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
        },
      );
    }


    Widget _displayDetails(BuildContext context, IncidentObject query, ReportIncidentProvider provider) {
      int selectedRating = 0;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(query.date??1747293525000);

      // Format the DateTime to a readable string
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Wrap the Text in a Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        query.incidentType ?? "Unknown Incident",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Ensure the delete icon remains visible
                    user!.content!.first.id == query.userId
                        ? InkWell(
                      onTap: () {
                        showDeletePopup(query, provider);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0), // Add spacing between text and icon
                        child: SvgPicture.asset(Images.delete),
                      ),
                    )
                        : SizedBox.shrink(),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  "Cheated By: ${query.cheatedBy ?? "N/A"}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (query.image != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BaseWidget().image(image: query.image!),
                  )
                else
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Date: ${formattedDate.toString() ?? "N/A"}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Amount Lost: ${query.amountLost ?? "N/A"}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Resolution: ${query.resolutionDetails ?? "N/A"}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "FIR Launched: ${query.isFirLounched == true ? "Yes" : "No"}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ThemeColor.theme_blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(selectedRating); // Return the rating
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    top_bar(BuildContext context, provider) {
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.h,
            decoration: const ShapeDecoration(
              color: Color(0xFFC3262C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45,),
                appBar(),

              ],
            )
          ),
          Positioned(bottom: 0,
              left: 50,
              right: 50,
              child:  searchBoxFilter())
        ],
      );
    }

    appBar(){
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(child:Icon(Icons.arrow_back_ios,color: Colors.white,),onTap: () { Navigator.pop(context); },),
            SizedBox(width: 16.w,),
            Text(
              "All Incident",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ],
        ),
      );
    }

    searchBoxFilter() {
      return Consumer<ReportIncidentProvider>(
        builder: (context, provider, child) {
          return Transform.translate(
            offset: Offset(0.0, 25.0.h),
            // Adjust as needed for vertical centering
            child: Center(
              // This ensures the search bar is centered
              child: serachBarFilter(),
            ),
          );
        },
      );
    }

    serachBarFilter() {
      return Consumer<ReportIncidentProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 260.w,
                height: 52.h,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
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
                                controller: provider.searchController,
                                onChanged: (value) {
                                  provider.getBySearchData();
                                },
                                decoration: InputDecoration(
                                    hintText: "Search here",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: const Color(0x662C363F),
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
            ],
          );
        },
      );
    }

    allNewsTag() {
      return Container(
        margin: EdgeInsets.only(left: 20.w, top: 0.h),
        child: Text(
          "All Incident",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      );
    }


    Future<void> showDeletePopup(IncidentObject incidentObj,ReportIncidentProvider provider) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
            content:  SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(S().deleteMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
                onPressed: () {
                  provider.deletePost(incidentObj, context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
}
