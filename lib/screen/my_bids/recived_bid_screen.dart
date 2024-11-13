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
import '../../provider/mybids/my_bids_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/card/base_widgets.dart';

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
          return


           widget.provider.isLoadMyPlacedBid && widget.provider.listOwnBid.isEmpty? Container(
              child: Center(
                child: Text(S().noRecordFound),
              ),
            ):ListView.builder(
            controller:widget.provider.scrollController,
            itemCount: widget.provider.listOwnBid.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h, left: 20.w, right: 20.w),
                child: iteamMyPost(widget.provider.listOwnBid[i], i),);
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
                  visible:postBidData.genericCardsDto!.expireDate==''?false:true,
                  child: Container(
                    width: 120.w,
                    height: 20.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2)
                      ),
                      border: Border.all(
                        width: 0.5,
                        color: ThemeColor.red,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text("valid till : ${postBidData.genericCardsDto!.expireDate==''?"-":postBidData.genericCardsDto!.expireDate!}",
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
                  width: 100.w,
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

          SizedBox(height: 8.h,),
          BaseWidget().headingWithoutDate(
              postBidData.genericCardsDto!.topicName!,
              postBidData.genericCardsDto!.content!),
          SizedBox(height: 8.h,),
          BaseWidget().routes(postBidData.genericCardsDto!.source!,
              postBidData.genericCardsDto!.destination!),
          SizedBox(height: 8.h,),
          postBidData.bidings!.isEmpty
              ? SizedBox.shrink()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart,
                  color: postBidData.genericCardsDto!.showCharts
                      ? ThemeColor.red
                      : Colors.grey),
              Switch(
                value: postBidData.genericCardsDto!.showCharts,
                onChanged: (value) async {
                  if (value == true) {
                    await widget.provider.getGraphDataForBids(
                        context, postBidData.genericCardsDto!.id!);
                  }
                  setState(() {
                    postBidData.genericCardsDto!.showCharts = value;
                  });
                },
                activeColor: ThemeColor.theme_blue,
              ),
              Icon(Icons.list,
                  color: !postBidData.genericCardsDto!.showCharts
                      ? ThemeColor.red
                      : Colors.grey),
            ],
          ),
          postBidData.genericCardsDto!.showCharts!
              ? drawGraph()
              : iteams(postBidData, index),
          SizedBox(height: 8.h,),
          BaseWidget().showBidButton((val) async{
            if (val == 0) {
              if (postBidData.bidings!.isNotEmpty) {
                showBootomSheet(context,postBidData.bidings);
              } else {
                ToastMessage.show(context, "There are no bids to show ");
              }
            }
            if(val==3){
              String description= "${postBidData.genericCardsDto!.mobileNumber.toString()}'Type : ${postBidData.genericCardsDto!.type}, \nSubject : ${postBidData.genericCardsDto!.content}, \nSource : ${postBidData.genericCardsDto!.source}, \nDestination : ${postBidData.genericCardsDto!.destination}, \nLink : https://api.tkdost.com/bids/?id=${postBidData.genericCardsDto!.id}'";
              await Utils().callShareFunction(description);
            }
          },true)


        ],
      ),
    );
  }

  void showBootomSheet(BuildContext context,List<Bidings>? bidings) async{
    User use=await LocalSharePreferences().getLoginData();
    if(use.content!.first.isPaid==0){

      Navigator.pushNamed(context, AppRoutes.registration_plan_details);

    }else{
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(heightFactor:0.7,child:ShowBidsScreen(listBidings: bidings,));
          });
    }
  }

  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.isEmpty) {
      return Container();
    } else {
      if (postBidData.bidings!.length == 1) {
        return iteamBid(postBidData.bidings![0], true, index);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], true, index)];
        return Column(
          children: list,
        );
      } else {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], false, index),
          iteamBid(postBidData.bidings![2], true, index)];
        return Column(
          children: list,
        );
      }
    }
  }

  iteamBid(Bidings bidings, bool isLast, int index) {
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

                  BaseWidget().getImage(bidings.profileImage!=null?bidings.profileImage!:"", height: 28.h, width: 28.w)
                  ,
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
                                  visible: bidings.isVerified!=0?true:false,
                                  child:   VerifiedTag().onVeriedTag(),
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
                            'Quote Justification : ${bidings.bidings!.description??'-'}',
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
                  onTap: () async{
                   // widget.provider.deleteBid(index, bidings);

                    User use=await LocalSharePreferences().getLoginData();
                    if(use.content!.first.isPaid==0){

                      Navigator.pushNamed(context, AppRoutes.registration_plan_details);

                    }else{
                      Utils().callFunction("${bidings.bidings!.mobileNumber}",);
                    }



                  }
                  , child: SizedBox(
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
                          SvgPicture.asset(Images.call_white,color: ThemeColor.theme_blue,height: 25.h,width: 25.w,)

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

  drawGraph() {
    return Consumer<MyBidsProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(9.0), // Outer padding for the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Y-axis label
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Quote Graph',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rotated Y-axis label
                RotatedBox(
                  quarterTurns: -1,
                  child: const Text(
                    'Quote Count',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                // Chart container with inner padding
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    // Space between label and chart
                    child: SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: _createBarGroups(provider),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) => Text(provider
                                    .data.keys
                                    .elementAt(value.toInt())),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0) {
                                    return Text(value.toString());
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(),
                          ),
                          gridData: FlGridData(show: false),
                          alignment: BarChartAlignment.spaceAround,
                          maxY: provider.data.values == 0
                              ? 0.0
                              : provider.data.values
                              .reduce((a, b) => a > b ? a : b) +
                              1.0,
                        ),
                        swapAnimationDuration: Duration(milliseconds: 500),
                        swapAnimationCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // X-axis label
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Quote Amount',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<BarChartGroupData> _createBarGroups(MyBidsProvider provider) {
    return provider.data.entries.map((entry) {
      final index = provider.data.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: double.parse(entry.value.toString()),
            color: Colors.blue,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }


}