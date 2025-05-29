import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/userdata.dart';
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
          return widget.provider.isLoadMyPlacedBid &&
                  widget.provider.listOwnBid.isEmpty
              ? Container(
                  child: Center(
                    child: Text(S().noRecordFound),
                  ),
                )
              : ListView.builder(
                  controller: widget.provider.scrollController,
                  itemCount: widget.provider.listOwnBid.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: 12.h, left: 20.w, right: 20.w),
                      child: iteamMyPost(widget.provider.listOwnBid[i], i),
                    );
                  },
                );
        },
      ),
    );
  }

  iteamMyPost(PostBidData postBidData, int index) {
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
          postBidData.bidings!.isEmpty
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list,
                        color: !postBidData.genericCardsDto!.showCharts
                            ? ThemeColor.red
                            : Colors.grey),
                    Switch(
                      value: postBidData.genericCardsDto!.showCharts,
                      onChanged: (value) async {
                        if (value == true) {
                          await widget.provider.getGraphDataForBids(
                              context, postBidData.genericCardsDto!.id!,index);
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
                  ],
                ),
          postBidData.genericCardsDto!.showCharts!
              ? drawGraph(postBidData)
              : iteams(postBidData, index),
          SizedBox(
            height: 8.h,
          ),
          BaseWidget().showBidButton((val) async {
            if (val == 0) {
              if (postBidData.bidings!.isNotEmpty) {
                showBootomSheet(context, postBidData.bidings,postBidData);
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
    );
  }

  void showBootomSheet(BuildContext context, List<Bidings>? bidings, PostBidData postBidData,) async {
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

  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.isEmpty) {
      return Container();
    } else {
      if (postBidData.bidings!.length == 1) {
        return iteamBid(postBidData.bidings![0], true, index,postBidData);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget> list = [
          iteamBid(postBidData.bidings![0], false, index,postBidData),
          iteamBid(postBidData.bidings![1], true, index,postBidData)
        ];
        return Column(
          children: list,
        );
      } else {
        List<Widget> list = [
          iteamBid(postBidData.bidings![0], false, index,postBidData),
          iteamBid(postBidData.bidings![1], false, index,postBidData),
          iteamBid(postBidData.bidings![2], true, index,postBidData)
        ];
        return Column(
          children: list,
        );
      }
    }
  }

  iteamBid(Bidings bidings, bool isLast, int index, PostBidData postBidData) {
    return Container(
      width: 311.w,
      //  height: 69.h,
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseWidget().getImage(
                      bidings.profileImage != null ? bidings.profileImage! : "",
                      height: 28.h,
                      width: 28.w),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${bidings.firstName!} ${bidings.lastName!}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Visibility(
                                  visible:
                                      bidings.isVerified != 0 ? true : false,
                                  child: VerifiedTag().onVeriedTag(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              bidings.companyName!,
                              style: TextStyle(
                                color: const Color(0x99001E49),
                                fontSize: 10.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹ ${bidings.bidings!.amount!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Quote Justification : ${bidings.bidings!.description ?? '-'}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: AppConstant.FONTFAMILY,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          bidings.isAccepted==1?
                          Text(
                           "Quote Accepted",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontFamily: AppConstant.FONTFAMILY,
                              fontWeight: FontWeight.w400,
                            ),
                          ): postBidData.genericCardsDto!.isOpenForBid==1?Button(
                            width: 100,
                            height: 35,
                            title: 'Accept quote',
                            onClick: () {
                              postBidData.genericCardsDto!.mainTag=="Full load required" || postBidData.genericCardsDto!.mainTag=="Part load required"
                                  ?showAcceptQuoteDialog(context,postBidData,bidings)
                                  :widget.provider.acceptBidSaveForm(context, postBidData,bidings,'','');
                            },
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: AppConstant.FONTFAMILY,
                              fontWeight: FontWeight.w400,
                            ),
                          ):SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 38.w,
            height: 38.h,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.07999999821186066),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    // widget.provider.deleteBid(index, bidings);

                    User use = await LocalSharePreferences().getLoginData();
                    if (use.content!.first.isPaid == 0) {
                      Navigator.pushNamed(
                          context, AppRoutes.registration_plan_details);
                    } else {
                      Utils().callFunction(
                        "${bidings.bidings!.mobileNumber}",
                      );
                    }
                  },
                  child: SizedBox(
                    width: 22.w,
                    height: 22.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: Stack(children: [
                            SvgPicture.asset(
                              Images.call_white,
                              color: ThemeColor.theme_blue,
                              height: 25.h,
                              width: 25.w,
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> showAcceptQuoteDialog(BuildContext context, PostBidData postBidData, Bidings bidings) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _driverNumberController = TextEditingController();
    final TextEditingController _vehicleNumberController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog( // Use Dialog for custom sizing
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Optional: Add rounded corners
          ),
          child: Container(
            height: 350, // Adjust height here
            padding: EdgeInsets.all(16), // Optional: Add padding inside the dialog
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
                  child: Expanded( // Use Expanded to handle overflow
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel',style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.provider.acceptBidSaveForm(context, postBidData,bidings,_driverNumberController.text,_vehicleNumberController.text);
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
                      padding: const EdgeInsets.only(left: 12.0,top: 30),
                      child: SizedBox(
                        height: 300,
                        width: xAxisLabels.length * 60.0, // Adjust dynamic width
                        child: BarChart(
                          BarChartData(
                            barGroups: chartData,
                            groupsSpace: 16, // Space between bar groups
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    // Display meaningful Y-axis titles at intervals
                                    if (value % 1 == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < xAxisLabels.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          xAxisLabels[value.toInt()],
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),

                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false), // Optionally show grid lines
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                //tooltipBgColor: Colors.black87,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  if (groupIndex < xAxisLabels.length) {
                                    final date = xAxisLabels[groupIndex];
                                    final nestedData = parsedData[date]?.entries.toList();
                                    if (nestedData != null && rodIndex < nestedData.length) {
                                      final entry = nestedData[rodIndex];
                                      return BarTooltipItem(
                                        '${entry.key}: ${entry.value}', // Display key and amount
                                        const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
