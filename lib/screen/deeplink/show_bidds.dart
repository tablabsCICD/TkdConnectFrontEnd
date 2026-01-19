import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../model/api_response.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/quoteResponse.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../network/geo_helper.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/editText.dart';
import '../../widgets/textview.dart';
import '../../widgets/verified_tag.dart';
import '../my_bids/show_bids_screen.dart';
import '../tracking/vehicle_tracking.dart';

class ShowAllBids extends StatefulWidget {
  final String id;
  const ShowAllBids({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _ShowAllBids();
}

class _ShowAllBids extends State<ShowAllBids> {
  bool isLoad = false;
  PostBidData? postBidData;

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyBidsProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                Images.arrow_back,
                height: 18,
                width: 18,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Bids",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          color: ThemeColor.baground,
          child: !isLoad
              ? _shimmerLoader()
              : iteamMyPost(postBidData!, provider),
        ),
      );
    });
  }

  // ============================================================
  // 🔄 SHIMMER LOADER
  // ============================================================
  Widget _shimmerLoader() {
    return ListView.builder(
      padding: EdgeInsets.all(12.r),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // 📦 MAIN CARD
  // ============================================================
  Widget iteamMyPost(PostBidData postBidData, MyBidsProvider provider) {
    return Opacity(
      opacity: postBidData.genericCardsDto!.isCompleted == 1 ? 1 : 1,
      child: Container(
        margin: EdgeInsets.all(12.r),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x114A5568),
              blurRadius: 8.r,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 TOP TAGS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (postBidData.genericCardsDto!.expireDate?.isNotEmpty ?? false)
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border:
                      Border.all(color: ThemeColor.red, width: 0.5),
                    ),
                    child: Text(
                      "Valid till: ${postBidData.genericCardsDto!.expireDate}",
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C8FEA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    Utils()
                        .mainTag(postBidData.genericCardsDto!.mainTag!),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // 🔹 HEADING
            BaseWidget().headingWithoutDate(
                postBidData.genericCardsDto!.topicName!,
                postBidData.genericCardsDto!.content!),

            SizedBox(height: 8.h),

            // 🔹 ROUTE
            BaseWidget().routes(
                postBidData.genericCardsDto!.source!,
                postBidData.genericCardsDto!.destination!),

            SizedBox(height: 12.h),

            // 🔹 SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("(Your quote)", style: TextStyle(fontSize: 10.sp)),
                SizedBox(width: 6.w),
                Icon(Icons.list,
                    color: !postBidData.genericCardsDto!.showCharts
                        ? ThemeColor.red
                        : Colors.grey),
                Switch(
                  value: postBidData.genericCardsDto!.showCharts,
                  onChanged: (value) async {
                    if (value) {
                      await provider.getGraphDataForBids(
                          context, postBidData.genericCardsDto!.id!, 0);
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
                SizedBox(width: 6.w),
                Text("(Avg Market Rate)", style: TextStyle(fontSize: 10.sp)),
              ],
            ),

            postBidData.genericCardsDto!.showCharts
                ? drawGraph(postBidData)
                : iteams(postBidData, provider),

            SizedBox(height: 8.h),

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
                    "${postBidData.genericCardsDto!.mobileNumber}'\n"
                    "Type: ${postBidData.genericCardsDto!.type}\n"
                    "Subject: ${postBidData.genericCardsDto!.content}\n"
                    "Source: ${postBidData.genericCardsDto!.source}\n"
                    "Destination: ${postBidData.genericCardsDto!.destination}\n"
                    "Link: https://tkdost.com/tkd/?id=${postBidData.genericCardsDto!.id}";
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


  // ============================================================
  // 📋 BIDS LIST
  // ============================================================
  Widget iteams(PostBidData postBidData, MyBidsProvider provider) {
    if (postBidData.bidings!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: postBidData.bidings!
          .take(3)
          .toList()
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final bid = entry.value;
        final isLast = index == postBidData.bidings!.take(3).length - 1;
        return itemBid(bid, isLast, postBidData, provider);
      }).toList(),
    );
  }

  // ============================================================
  // 👤 SINGLE BID ITEM (RESPONSIVE)
  // ============================================================
  Widget itemBid(Bidings bidings, bool isLast, PostBidData postBidData,
      MyBidsProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.transparent : const Color(0x332C363F),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseWidget().getImage(
            bidings.profileImage ?? "",
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(width: 10.w),

          // 🔹 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${bidings.firstName!} ${bidings.lastName!}",
                      style: TextStyle(
                        fontSize: 12.sp,
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
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '₹ ${bidings.bidings?.amount ?? '-'}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Quote: ${bidings.bidings?.description ?? '-'}',
                  style: TextStyle(fontSize: 11.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // 🔹 ACTIONS
                if (bidings.isAccepted == 1) ...[
                  SizedBox(height: 6.h),
                  Text("Quote Accepted",
                      style: TextStyle(color: Colors.green, fontSize: 11.sp)),
                  Text("Vehicle: ${bidings.vehicleNumber ?? ''}",
                      style: TextStyle(fontSize: 11.sp)),
                  Text("Driver: ${bidings.driverContact ?? ''}",
                      style: TextStyle(fontSize: 11.sp)),
                ] else if (postBidData.genericCardsDto?.isOpenForBid == 1)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Button(
                      width: 110,
                      height: 36,
                      title: 'Accept Quote',
                      onClick: () {
                        provider.acceptBidSaveForm(
                            context, postBidData, bidings, '', '');
                      },
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
              ],
            ),
          ),

          // 🔹 CALL BUTTON
          InkWell(
            onTap: () async {
              User use = await LocalSharePreferences().getLoginData();
              if (use.content?.first.isPaid == 0) {
                Navigator.pushNamed(
                    context, AppRoutes.registration_plan_details);
              } else {
                Utils().callFunction("${bidings.bidings?.mobileNumber}");
              }
            },
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: ThemeColor.theme_blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 📊 GRAPH (MOBILE OPTIMIZED)
  // ============================================================
  Widget drawGraph(PostBidData postBidData) {
    return Consumer<MyBidsProvider>(builder: (context, provider, child) {
      final graphList = postBidData.genericCardsDto?.graphList ?? [];
      final parsedData = prepareChartData(graphList);
      final xAxisLabels = parsedData.keys.toList();
      final chartData = _createBarGroups(parsedData, xAxisLabels);

      return SizedBox(
        height: 260.h,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: xAxisLabels.length * 60.w,
            child: BarChart(
              BarChartData(
                barGroups: chartData,
                groupsSpace: 16,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 9.sp),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < xAxisLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              xAxisLabels[value.toInt()],
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ),
      );
    });
  }

  // ============================================================
  // 🔧 HELPERS
  // ============================================================
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
      List<String> xAxisLabels) {
    return xAxisLabels.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final nestedValues = parsedData[date] ?? {};
      final barRods = nestedValues.entries.map((e) {
        return BarChartRodData(
          toY: e.value.toDouble(),
          width: 10,
          borderRadius: BorderRadius.circular(4),
          color: Colors.blueAccent,
        );
      }).toList();

      return BarChartGroupData(
        x: index,
        barRods: barRods,
        barsSpace: 4,
      );
    }).toList();
  }

  // ============================================================
  // 🌐 API CALL
  // ============================================================
  void callApi() async {
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(
        "${ApiConstant.BASE_URL}getPostAndBidByPostId?postId=${widget.id}");
    if (apiResponse.status == 200) {
      PostBidData bidPlaced =
      PostBidData.fromJson(apiResponse.response);
      postBidData = bidPlaced;
      setState(() {
        isLoad = true;
      });
    } else {
      ToastMessage.show(context, "Please try again later");
    }
  }
}
