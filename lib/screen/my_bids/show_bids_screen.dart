import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/editText.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';
import '../../network/geo_helper.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/textview.dart';
import '../../widgets/verified_tag.dart';
import '../tracking/vehicle_tracking.dart';

class ShowBidsScreen extends StatelessWidget{
  final List<Bidings>? listBidings;
  PostBidData postBidData;


  ShowBidsScreen({super.key, required this.listBidings,required this.postBidData, });
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 20.w,top: 12.h,right: 20.w),
          child: Column(
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Textview(
                      title: S().myQuotes,
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap:(){
                      Navigator.pop(context);
                    },child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 24.h,),

              Expanded(
                child: ListView.builder(
                    itemCount: listBidings!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return itemBid(listBidings![index], false, index,postBidData,context);
                    }),
              )

            ],

          ),
        ),
      ),

    );
  }


  Widget itemBid(Bidings bidings, bool isLast, int index, PostBidData postBidData,BuildContext context) {
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
                      if (bidings.isAccepted == 1)
                        ...[
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
                              final startCoords = await GeoHelper.getLatLngFromCity(postBidData.genericCardsDto?.source ?? "");
                              final endCoords = await GeoHelper.getLatLngFromCity(postBidData.genericCardsDto?.destination ?? "");

                              if (startCoords != null && endCoords != null) {
                                LatLng startLatLong = LatLng(startCoords['lat']!, startCoords['lng']!);
                                LatLng endLatLong = LatLng(endCoords['lat']!, endCoords['lng']!);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VehicleTrackingWithTwoPolylines(
                                        startLocation: startLatLong,
                                        endLocation: endLatLong,
                                        vehicleId: bidings.vehicleNumber ?? '',
                                        driverNumber: bidings.driverContact ?? '',
                                        postId:postBidData.genericCardsDto!.id
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


                        ]
                      else if (postBidData.genericCardsDto?.isOpenForBid == 1)
                        Button(
                          width: 100,
                          height: 35,
                          title: 'Accept quote',
                          onClick: () {
                            if (["Full load required", "Part load required"].contains(postBidData.genericCardsDto?.mainTag)) {
                              showAcceptQuoteDialog(context, postBidData, bidings);
                            } else {
                              Provider.of<MyBidsProvider>(context, listen: false).acceptBidSaveForm(context, postBidData, bidings, '', '');
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
            child: Center(
              child: InkWell(
                onTap: () async {
                  User use = await LocalSharePreferences().getLoginData();
                  if (use.content?.first.isPaid == 0) {
                    Navigator.pushNamed(context, AppRoutes.registration_plan_details);
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
                          Provider.of<MyBidsProvider>(context, listen: false).acceptBidSaveForm(context, postBidData,bidings,_driverNumberController.text,_vehicleNumberController.text);
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