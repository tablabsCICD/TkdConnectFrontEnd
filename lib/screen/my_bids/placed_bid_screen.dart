import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/bid_placed.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../generated/l10n.dart';
import '../../network/geo_helper.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/editText.dart';
import '../tracking/vehicle_tracking.dart';

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
        return widget.provider.isLoad && provider.listBids.isEmpty ? Container(
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
            color: const Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
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
                color: const Color(0xFF2C8FEA),
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
                    color: const Color(0x99001E49),
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
          Text(
            bids.description??"",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            // overflow: TextOverflow.ellipsis,
          ), SizedBox(
            height: 12.h,
          ),
          BaseWidget().routes(bids.source!, bids.destination!),
          SizedBox(
            height: 12.h,
          ),
          BaseWidget().heading(bids.topicName!, bids.postingTime!.split(" ").first, bids.content!),
          bids.isAccepted==0?SizedBox.shrink():Column(
            children: [
              Text(
                Utils().mainTag(bids.mainTag!)=="Full vehicle required" ||  Utils().mainTag(bids.mainTag!)=="Part vehicle required"
                    ?'Your Quote is accepted kindly share driver contact number and vehicle number.':"",
                style: TextStyle(color: Colors.orange, fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,),
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
                    bids.vehicleNumber ?? '',
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
                    bids.driverContact ?? "",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              ActionChip(
                avatar: const Icon(Icons.location_on_outlined, size: 18, color: Colors.white),
                label: const Text(
                  "Track",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)), // 🔹 No rounded corners
                ),
                onPressed: () async {
                  final startCoords = await GeoHelper.getLatLngFromCity(bids.source ?? "");
                  final endCoords = await GeoHelper.getLatLngFromCity(bids.destination ?? "");

                  if (startCoords != null && endCoords != null) {
                    LatLng startLatLong = LatLng(startCoords['lat']!, startCoords['lng']!);
                    LatLng endLatLong = LatLng(endCoords['lat']!, endCoords['lng']!);
                    print("${startLatLong}${endLatLong}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleTrackingWithTwoPolylines(
                            startLocation: startLatLong,
                            endLocation: endLatLong,
                            vehicleId: bids.vehicleNumber ?? '',
                            driverNumber: bids.driverContact ?? '',
                            postId:bids.id
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to get location from city")),
                    );
                  }
                },
              )
            ],
          ),
          bids.isAccepted==0?BaseWidget().onlyBidButton((){
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

          }):InkWell(
            onTap: () {
              Utils().mainTag(bids.mainTag!)=="Full vehicle required" ||  Utils().mainTag(bids.mainTag!)=="Part vehicle required"
              ?showAcceptQuoteDialog(context,bids,provider):null;
            },
            child: Container(
              height: 38.h,
              width: double.infinity,
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
                    Utils().mainTag(bids.mainTag!)=="Full vehicle required" ||  Utils().mainTag(bids.mainTag!)=="Part vehicle required"
                        ?"Click to share details":"Your Quote is accepted",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<void> showAcceptQuoteDialog(BuildContext context, Bids bids,MyBidsProvider provider) async {
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
                          provider.updateAcceptBid(context, bids,_driverNumberController.text,_vehicleNumberController.text);
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
}
