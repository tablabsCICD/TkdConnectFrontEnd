
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
import '../../widgets/common_app_bar.dart';



class ReportIncidentList extends StatefulWidget {
  const ReportIncidentList({super.key});

  @override
  State<ReportIncidentList> createState() => _ReportIncidentListState();
}

class _ReportIncidentListState extends State<ReportIncidentList> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    user = await LocalSharePreferences.localSharePreferences.getLoginData();
    if (mounted) setState(() {}); // refresh UI when user is loaded
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportIncidentProvider>(
      // 👉 Provider created ONCE here; it fetches “All Incidents” immediately.
      create: (_) {
        final p = ReportIncidentProvider();
        p.toggleMyReport(false); // load 'All Incidents' on start
        return p;
      },
      child: Consumer<ReportIncidentProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFloatingButton(context, provider),
            body: Container(
              color: ThemeColor.baground,
              child: Column(
                children: [
                  CommonAppBar(
                    title: "All Incident",
                    isBack: true,
                    isTitle: true,
                    isSearchBar: true,
                    isFilter: false,
                    onBackTap: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 30.h),
                  _buildLostAmtWidget(provider),
                  SizedBox(height: 10.h),
                  _buildFilterChips(provider),
                  Expanded(
                    child: provider.allReport.isEmpty
                        ? _buildEmptyState(context)
                        : RefreshIndicator(
                      onRefresh: provider.LoadReports,
                      child: _buildReportList(provider),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /*──────────────────────────*
   *   UI helper widgets      *
   *──────────────────────────*/

  Widget _buildFloatingButton(BuildContext context, ReportIncidentProvider provider) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.reportIncident);
        await provider.toggleMyReport(provider.myIncident); // Refresh after returning
      },
      child: Container(
        width: 180.w,
        height: 38.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: ThemeColor.theme_blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Text(
          S.of(context).reportIncident,
          style: TextStyle(
            color: ThemeColor.progress_color,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          S.of(context).noRecordFound,
          style: TextStyle(
            color: ThemeColor.theme_blue,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ReportIncidentProvider provider) {
    return Container(
      margin: EdgeInsets.only(left: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _chip(
            label: S.of(context).allIncident,
            selected: !provider.myIncident,
            onSelected: () => provider.toggleMyReport(false),
          ),
          _chip(
            label: S.of(context).myIncident,
            selected: provider.myIncident,
            onSelected: () => provider.toggleMyReport(true),
          ),
        ],
      ),
    );
  }

  Widget _chip({required String label, required bool selected, required VoidCallback onSelected}) {
    return ChoiceChip(
      backgroundColor: Colors.transparent,
      selectedColor: ThemeColor.theme_blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: ThemeColor.theme_blue),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }

  Widget _buildReportList(ReportIncidentProvider provider) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: provider.allReport.length,
      itemBuilder: (context, index) {
        final report = provider.allReport[index];
        final date = DateTime.fromMillisecondsSinceEpoch(report.date ?? 0);
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => _displayDetails(context, report, provider),
                );
              },
              child: _reportCard(report, formattedDate),
            ),
            if (user != null && report.userId == user!.content!.first.id)
              Positioned(
                top: 6,
                right: 10,
                child: _deleteButton(report, provider),
              ),
          ],
        );
      },
    );
  }

  Card _reportCard(IncidentObject report, String formattedDate) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: BaseWidget().image(image: report.image!),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              report.incidentType ?? "Unknown Incident",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.person, "Cheated By", report.cheatedBy ?? "N/A"),
            _infoRow(Icons.currency_rupee, "Amount Lost", report.amountLost ?? "N/A"),
            _infoRow(Icons.calendar_month, "Date", formattedDate),
            _infoRow(Icons.shield_moon, "FIR Launched", report.isFirLounched == true ? "Yes" : "No"),
            _infoRow(Icons.description, "Resolution", report.resolutionDetails ?? "N/A"),
          ],
        ),
      ),
    );
  }

  Widget _deleteButton(IncidentObject report, ReportIncidentProvider provider) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Report"),
            content: const Text("Are you sure you want to delete this report?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.deletePost(report, context);
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.red.shade50,
        child: SvgPicture.asset(Images.delete, width: 20.w, height: 20.w),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.grey[800],
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*──────────────────────────*
   *      Detail Dialog       *
   *──────────────────────────*/

  Widget _displayDetails(BuildContext ctx, IncidentObject query, ReportIncidentProvider provider) {
    final date = DateTime.fromMillisecondsSinceEpoch(query.date ?? 0);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          if (user != null && query.userId == user!.content!.first.id)
            InkWell(
              onTap: () => _showDeletePopup(query, provider),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SvgPicture.asset(Images.delete),
              ),
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
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
                child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
              ),
            const SizedBox(height: 16),
            _infoRow(Icons.person, "Cheated By", query.cheatedBy ?? "N/A"),
            _infoRow(Icons.currency_rupee, "Amount Lost", query.amountLost ?? "N/A"),
            _infoRow(Icons.calendar_month, "Date", formattedDate),
            _infoRow(Icons.shield_moon, "FIR Launched", query.isFirLounched == true ? "Yes" : "No"),
            _infoRow(Icons.description, "Resolution", query.resolutionDetails ?? "N/A"),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ThemeColor.theme_blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  /*──────────────────────────*
   *       App Bar / Top      *
   *──────────────────────────*/

  Widget _topBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.h,
          decoration: const ShapeDecoration(
            color: Color(0xFFC3262C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              _appBarRow(context),
            ],
          ),
        ),
        Positioned(bottom: 0, left: 50, right: 50, child: _searchBox()),
      ],
    );
  }

  Widget _appBarRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          Text(
            "All Incident",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /*──────────────────────────*
   *      Search Box UI       *
   *──────────────────────────*/

  Widget _searchBox() => Consumer<ReportIncidentProvider>(
    builder: (context, provider, child) {
      return Transform.translate(
        offset: Offset(0.0, 25.0.h),
        child: Center(child: _searchField(provider)),
      );
    },
  );

  Widget _searchField(ReportIncidentProvider provider) {
    return Container(
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
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: SvgPicture.asset(Images.search_normal, width: 24.w, height: 24.h),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: provider.searchController,
              onChanged: (_) => provider.getBySearchData(),
              decoration: InputDecoration(
                hintText: "Search here",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: const Color(0x662C363F),
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*──────────────────────────*
   *     Delete Confirmation  *
   *──────────────────────────*/

  Future<void> _showDeletePopup(IncidentObject item, ReportIncidentProvider provider) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(S().delete, style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.theme_blue)),
          content: SingleChildScrollView(
            child: ListBody(children: [Text(S().deleteMsg, style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.theme_blue))]),
          ),
          actions: [
            TextButton(
              child: Text(S().delete, style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.red)),
              onPressed: () {
                provider.deletePost(item, ctx);
                Navigator.of(ctx).pop(); // close dialog
                Navigator.of(context).pop(); // close detail
              },
            ),
            TextButton(
              child: Text(S().no, style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.green)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );
  }

  _buildLostAmtWidget(ReportIncidentProvider provider) {
    return Container(
      height: 78,
      margin: const EdgeInsets.symmetric(horizontal: 16), // horizontal margin
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Images.new_report_incident,
              height: 22,
              width: 22,

            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
             "Total Amount",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              provider.totalLostAmt,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
