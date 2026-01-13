import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/geo_helper.dart';
import 'package:tkd_connect/provider/my_post/my_post_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/my_bids/show_bids_screen.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/verified_tag.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/quoteResponse.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/editText.dart';
import '../tracking/vehicle_tracking.dart';

class RecivedBidScreen extends StatefulWidget {
  final MyBidsProvider provider;

  const RecivedBidScreen({super.key, required this.provider});

  @override
  State<StatefulWidget> createState() {
    return _RecivedBidScreenState();
  }
}

class _RecivedBidScreenState extends State<RecivedBidScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.provider.getReceviedBids(context, true);
    widget.provider.pagenation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<MyBidsProvider>(
        builder: (context, provider, child) {
          return provider.isLoadMyPlacedBid && provider.listOwnBid.isEmpty
              ? Container(
                  child: Center(
                    child: Text(S().noRecordFound),
                  ),
                )
              : ListView.builder(
                  controller: provider.scrollController,
                  itemCount: provider.listOwnBid.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: 12.h, left: 20.w, right: 20.w),
                      child: iteamMyPost(provider.listOwnBid[i], i, provider),
                    );
                  },
                );
        },
      ),
    );
  }

  iteamMyPost(PostBidData postBidData, int index, MyBidsProvider provider) {
    return Opacity(
      opacity: postBidData.genericCardsDto!.isCompleted == 1?0.5:1,
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Visibility(
                    visible: postBidData.genericCardsDto!.expireDate == ''
                        ? false
                        : true,
                    child: Container(
                      width: 120.w,
                      height: 20.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(
                          width: 0.5,
                          color: ThemeColor.red,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "valid till : ${postBidData.genericCardsDto!.expireDate == '' ? "-" : postBidData.genericCardsDto!.expireDate!}",
                          style: TextStyle(
                            color: ThemeColor.black,
                            fontSize: 8.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 120.w,
                    height: 18.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2C8FEA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r)),
                    ),
                    child: Center(
                      child: Text(
                        Utils().mainTag(postBidData.genericCardsDto!.mainTag!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            BaseWidget().headingWithoutDate(
                postBidData.genericCardsDto!.topicName!,
                postBidData.genericCardsDto!.content!),
            SizedBox(
              height: 8.h,
            ),
            BaseWidget().routes(postBidData.genericCardsDto!.source!,
                postBidData.genericCardsDto!.destination!),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "(Your quote)",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Icon(Icons.list,
                    color: !postBidData.genericCardsDto!.showCharts
                        ? ThemeColor.red
                        : Colors.grey),
                Switch(
                  value: postBidData.genericCardsDto!.showCharts,
                  onChanged: (value) async {
                    if (value == true) {
                      await provider.getGraphDataForBids(
                          context, postBidData.genericCardsDto!.id!, index);
                    }
                    setState(() {
                      postBidData.genericCardsDto!.showCharts = value;
                    });
                  },
                  activeColor: ThemeColor.theme_blue,
                ),
                Icon(Icons.bar_chart,
                    color: postBidData.genericCardsDto!.showCharts
                        ? ThemeColor.red
                        : Colors.grey),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "(Average Market Rate)",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            postBidData.genericCardsDto!.showCharts!
                ? drawGraph(postBidData)
                : iteams(postBidData, index, provider),
            SizedBox(
              height: 8.h,
            ),
            BaseWidget().showBidButton((val) async {
              if (val == 0) {
                if (postBidData.bidings!.isNotEmpty) {
                  showBootomSheet(context, postBidData.bidings, postBidData);
                } else {
                  ToastMessage.show(context, "There are no bids to show ");
                }
              }
              if (val == 3) {
                String description =
                    "${postBidData.genericCardsDto!.mobileNumber.toString()}'Type : ${postBidData.genericCardsDto!.type}, \nSubject : ${postBidData.genericCardsDto!.content}, \nSource : ${postBidData.genericCardsDto!.source}, \nDestination : ${postBidData.genericCardsDto!.destination}, \nLink : https://tkdost.com/tkd/?id=${postBidData.genericCardsDto!.id}";
                await Utils().callShareFunction(description);
              }
            }, true)
          ],
        ),
      ),
    );
  }

  void showBootomSheet(
    BuildContext context,
    List<Bidings>? bidings,
    PostBidData postBidData,
  ) async {
    User use = await LocalSharePreferences().getLoginData();
    if (use.content!.first.isPaid == 0) {
      Navigator.pushNamed(context, AppRoutes.registration_plan_details);
    } else {
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
                heightFactor: 0.7,
                child: ShowBidsScreen(
                  listBidings: bidings,
                  postBidData: postBidData,
                ));
          });
    }
  }

  iteams(PostBidData postBidData, int index, MyBidsProvider provider) {
    if (postBidData.bidings!.isEmpty) {
      return Container();
    } else {
      if (postBidData.bidings!.length == 1) {
        return itemBid(
            postBidData.bidings![0], true, index, postBidData, provider);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget> list = [
          itemBid(postBidData.bidings![0], false, index, postBidData, provider),
          itemBid(postBidData.bidings![1], true, index, postBidData, provider)
        ];
        return Column(
          children: list,
        );
      } else {
        List<Widget> list = [
          itemBid(postBidData.bidings![0], false, index, postBidData, provider),
          itemBid(postBidData.bidings![1], false, index, postBidData, provider),
          itemBid(postBidData.bidings![2], true, index, postBidData, provider)
        ];
        return Column(
          children: list,
        );
      }
    }
  }

  Widget itemBid(Bidings bidings, bool isLast, int index,
      PostBidData postBidData, MyBidsProvider provider) {
    return Container(
      width: 311.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.white : const Color(0x332C363F),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile, Name, Company, Quote Panel
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseWidget().getImage(
                  bidings.profileImage ?? "",
                  height: 28.h,
                  width: 28.w,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Verified tag
                      Row(
                        children: [
                          Text(
                            "${bidings.firstName!} ${bidings.lastName!}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontFamily: AppConstant.FONTFAMILY,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          if (bidings.isVerified != 0)
                            VerifiedTag().onVeriedTag(),
                        ],
                      ),
                      Text(
                        bidings.companyName ?? '',
                        style: TextStyle(
                          color: const Color(0x99001E49),
                          fontSize: 10.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '₹ ${bidings.bidings?.amount ?? '-'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Quote Justification : ${bidings.bidings?.description ?? '-'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Accepted Quote details and actions
                      if (bidings.isAccepted == 1) ...[
                        SizedBox(height: 4.h),
                        Text(
                          "Quote Accepted",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Vehicle Number : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              bidings.vehicleNumber ?? '',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Driver Number : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              bidings.driverContact ?? "",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        postBidData.genericCardsDto?.isCompleted == 1
                            ? const SizedBox.shrink()
                            : ((bidings.driverContact != null &&
                                        bidings.driverContact!.isNotEmpty) ||
                                    (bidings.driverContact != null &&
                                        bidings.driverContact == ""))
                                ? ActionChip(
                                    avatar: const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      postBidData.genericCardsDto!
                                                  .ispostOwnerVerifiedForTrack ==
                                              0
                                          ? "Track Driver"
                                          : "Track Ride",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    onPressed: () async {
                                      bool verifying = postBidData
                                              .genericCardsDto!
                                              .ispostOwnerVerifiedForTrack !=
                                          0;

                                      if (verifying) {
                                        final startCoords =
                                            await GeoHelper.getLatLngFromCity(
                                                postBidData.genericCardsDto
                                                        ?.source ??
                                                    "");
                                        final endCoords =
                                            await GeoHelper.getLatLngFromCity(
                                                postBidData.genericCardsDto
                                                        ?.destination ??
                                                    "");

                                        if (startCoords != null &&
                                            endCoords != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  VehicleTrackingWithTwoPolylines(
                                                startLocation: LatLng(
                                                    startCoords['lat']!,
                                                    startCoords['lng']!),
                                                endLocation: LatLng(
                                                    endCoords['lat']!,
                                                    endCoords['lng']!),
                                                vehicleId:
                                                    bidings.vehicleNumber ?? '',
                                                driverNumber:
                                                    bidings.driverContact ?? '',
                                                postId: postBidData
                                                    .genericCardsDto?.id,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (dialogCtx) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Send OTP To Verify Driver"),
                                              content: const Text(
                                                  "Send OTP for driver verification."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final success = await widget
                                                        .provider
                                                        .isUserDeleted(
                                                      bidings.driverContact ??
                                                          "",
                                                      context,
                                                      postBidData
                                                          .genericCardsDto!.id!,
                                                      true,
                                                    );

                                                    if (success) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      ToastMessage.show(
                                                        context,
                                                        "Failed to send OTP",
                                                      );
                                                    }
                                                  },
                                                  child: const Text("Send OTP"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                : const SizedBox.shrink()
                      ] else if (postBidData.genericCardsDto?.isOpenForBid == 1)
                        Button(
                          width: 100,
                          height: 35,
                          title: 'Accept quote',
                          onClick: () {
                            if ([
                              "Full load required",
                              "Part load required"
                            ].contains(postBidData.genericCardsDto?.mainTag)) {
                              showAcceptQuoteDialog(
                                  context, postBidData, bidings, provider);
                            } else {
                              provider.acceptBidSaveForm(
                                  context, postBidData, bidings, '', '');
                            }
                          },
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Call Button Panel
          Container(
            width: 38.w,
            height: 38.h,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
            child: Center(
              child: InkWell(
                onTap: () async {
                  User use = await LocalSharePreferences().getLoginData();
                  if (use.content?.first.isPaid == 0) {
                    Navigator.pushNamed(
                        context, AppRoutes.registration_plan_details);
                  } else {
                    Utils().callFunction("${bidings.bidings?.mobileNumber}");
                  }
                },
                child: SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: SvgPicture.asset(
                    Images.call_white,
                    color: ThemeColor.theme_blue,
                    height: 25.h,
                    width: 25.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAcceptQuoteDialog(BuildContext context,
      PostBidData postBidData, Bidings bidings, MyBidsProvider provider) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _driverNumberController =
        TextEditingController();
    final TextEditingController _vehicleNumberController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // Use Dialog for custom sizing
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Optional: Add rounded corners
          ),
          child: Container(
            height: 350,
            // Adjust height here
            padding: EdgeInsets.all(16),
            // Optional: Add padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Accept Quote",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        labelText("Vehicle Number"),
                        SizedBox(height: 8),
                        EditTextError(
                          validate: true,
                          width: 335.w,
                          height: 52.h,
                          hint: "Vehicle Number",
                          controller: _vehicleNumberController,
                          onChange: (val) {},
                        ),
                        SizedBox(height: 12),
                        labelText("Driver Number"),
                        SizedBox(height: 8),
                        EditTextError(
                          validate: true,
                          width: 335.w,
                          height: 52.h,
                          keybordType: TextInputType.number,
                          hint: "Driver Contact Number",
                          controller: _driverNumberController,
                          onChange: (val) {},
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.provider.acceptBidSaveForm(
                              context,
                              postBidData,
                              bidings,
                              _driverNumberController.text,
                              _vehicleNumberController.text);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  labelText(String label) {
    return SizedBox(
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

  Map<String, Map<String, int>> prepareChartData(List<MonthData> response) {
    Map<String, Map<String, int>> chartData = {};

    for (var monthData in response) {
      Map<String, int> labelValues = {};
      for (var item in monthData.list!) {
        labelValues[item.label!] = int.parse(item.value.toString());
      }
      chartData[monthData.month!] = labelValues;
    }

    return chartData;
  }

  List<BarChartGroupData> _createBarGroups(
    Map<String, Map<String, int>> parsedData,
    List<String> xAxisLabels,
  ) {
    return xAxisLabels.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final nestedValues = parsedData[date] ?? {};

      final barRods = nestedValues.entries.map((e) {
        return BarChartRodData(
          toY: e.value.toDouble(),
          width: 12,
          borderRadius: BorderRadius.circular(4),
          color: Colors.blueAccent,
        );
      }).toList();

      return BarChartGroupData(
        x: index,
        barRods: barRods,
        barsSpace: 4,
        showingTooltipIndicators: List.generate(barRods.length, (i) => i),
      );
    }).toList();
  }

  Widget drawGraph(PostBidData postBidData) {
    return Consumer<MyBidsProvider>(builder: (context, provider, child) {
      // Parse data
      final graphList = postBidData.genericCardsDto?.graphList ?? [];
      final parsedData = prepareChartData(graphList);
      final xAxisLabels = parsedData.keys.toList();
      final chartData = _createBarGroups(parsedData, xAxisLabels);

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text(
                "Recent Quote Analysis Overview",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rotated Y-axis label
                const RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    'Quote Count',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                // Horizontal scrollable chart container
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 30),
                      child: SizedBox(
                        height: 300,
                        width: xAxisLabels.length * 60.0,
                        // Adjust dynamic width
                        child: BarChart(
                          BarChartData(
                            barGroups: chartData,
                            groupsSpace: 16,
                            // Space between bar groups
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    // Display meaningful Y-axis titles at intervals
                                    if (value % 1 == 0) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < xAxisLabels.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          xAxisLabels[value.toInt()],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),

                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            // Optionally show grid lines
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                //tooltipBgColor: Colors.black87,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  if (groupIndex < xAxisLabels.length) {
                                    final date = xAxisLabels[groupIndex];
                                    final nestedData =
                                        parsedData[date]?.entries.toList();
                                    if (nestedData != null &&
                                        rodIndex < nestedData.length) {
                                      final entry = nestedData[rodIndex];
                                      return BarTooltipItem(
                                        '${entry.key}: ${entry.value}',
                                        // Display key and amount
                                        const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  }
                                  return null; // Return null for invalid data
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // X-axis label
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Quote Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
