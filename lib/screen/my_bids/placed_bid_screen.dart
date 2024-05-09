import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/bid_placed.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../generated/l10n.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';

class PlacedBidScreen extends StatefulWidget {
  final MyBidsProvider provider;

  const PlacedBidScreen({super.key, required this.provider});

  @override
  State<StatefulWidget> createState() {
    return _PlacedBidScrrenState();
  }
}

class _PlacedBidScrrenState extends State<PlacedBidScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.provider.getAllBids(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyBidsProvider>(
      builder: (context, provider, child) {
        return widget.provider.isLoad && provider.listBids.length==0 ? Container(
          child: Center(
            child: Text(S().noRecordFound),
          ),
        ):ListView.builder(
            itemCount: provider.listBids.length,
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              return Container(
                // transform: Matrix4.translationValues(0.0, -45.0.h, 0.0),
                  child: Padding(padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 20.h),child: cardLoad(index, context, provider.listBids[index],provider)));
            });

      },
    );
  }

  cardLoad(int index, BuildContext context, Bids bids,MyBidsProvider provider) {
    return Container(
      width: 335.w,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 120.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  Utils().mainTag(bids.mainTag!),

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
          Container(
            transform: Matrix4.translationValues(0.0, -20.0.h, 0.0),
            child: Column(
              children: [
                Text(
                  S().quotesPrice,
                  style: TextStyle(
                    color: Color(0x99001E49),
                    fontSize: 10.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  '₹ ${bids.amount}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          BaseWidget().routes(bids.source!, bids.destination!),
          SizedBox(
            height: 12.h,
          ),
          BaseWidget().heading(bids.topicName!, bids.postingTime!.split(" ").first, bids.content!),
          BaseWidget().onlyBidButton((){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Withdraw quote',style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),),
                  content: Text('Are you sure you want to withdraw this quote?',style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {

                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,),),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.deleteBid(index, bids, context);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.red, fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ],
                );
              },
            );

          })
        ],
      ),
    );
  }
}
