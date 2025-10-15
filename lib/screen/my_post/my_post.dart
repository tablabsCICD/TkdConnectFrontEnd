import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/my_post/my_post_provider.dart';
import 'package:tkd_connect/provider/mybids/my_bids_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../generated/l10n.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';
import '../../network/geo_helper.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widgets/button.dart';
import '../../widgets/editText.dart';
import '../../widgets/verified_tag.dart';
import '../my_bids/show_bids_screen.dart';
import '../tracking/vehicle_tracking.dart';


class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyPostState();
  }

}

class _MyPostState extends State<MyPostScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyPostProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(child: Container(
        child: Column(
          children: [
            BaseWidget().appBar(context, S().myPost),
            SizedBox(height: 20.h,),
            Expanded(
              child: Consumer<MyPostProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    controller: provider.scrollController,
                    itemCount: provider.listOwnBid.length,
                    itemBuilder: (context, i) {
                      return Padding(padding: EdgeInsets.only(bottom: 12.h,left: 20.w,right: 20.w),child: iteamMyPost(provider.listOwnBid[i],i),);
                    },
                  );
                },
              ),
            )

          ],
        ),
      )),
    );
  }


  iteamMyPost(PostBidData postBidData, int index) {

  return Consumer<MyPostProvider>(
  builder: (context, provider, child) {
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
                          color: ThemeColor.green,
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
          BaseWidget().heading(
              postBidData.genericCardsDto!.topicName!,
              postBidData.genericCardsDto!.postingTime!=null?postBidData.genericCardsDto!.postingTime!.split(" ").first:"",
              postBidData.genericCardsDto!.content!),
          SizedBox(height: 8.h,),
          BaseWidget().routes(postBidData.genericCardsDto!.source!,
              postBidData.genericCardsDto!.destination!),
          SizedBox(height: 8.h,),
          iteams(postBidData, index),
          SizedBox(height: 8.h,),
          BaseWidget().showBidButton((val) async{
            if (val == 0) {
              if (postBidData.bidings!.isNotEmpty) {
                showBootomSheet(context,postBidData.bidings,postBidData,);
              } else {
                ToastMessage.show(context, "No any Bids to show");
              }
            }
            if(val==1){

              Future.delayed(
                  Duration.zero,
                      () => _showMyDialog(index,provider)
              );

              
            }
            if(val==3){
              String description= "${postBidData.genericCardsDto!.mobileNumber.toString()}'Type : ${postBidData.genericCardsDto!.type}, \nSubject : ${postBidData.genericCardsDto!.content}, \nSource : ${postBidData.genericCardsDto!.source}, \nDestination : ${postBidData.genericCardsDto!.destination}, \nLink : https://api.tkdost.com/bids/?id=${postBidData.genericCardsDto!.id}'";
              await Utils().callShareFunction(description);
            }
          },false),


        ],
      ),
    );
  },
);
  }

  Future<void> _showMyDialog(int index,MyPostProvider myPostProvider) async {
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
                myPostProvider.deletePost(index, context);
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

  void showBootomSheet(BuildContext context,List<Bidings>? bidings,PostBidData postBidData)async {
    User use=await LocalSharePreferences().getLoginData();
    if(use.content!.first.isPaid==0){

      Navigator.pushNamed(context, AppRoutes.registration_plan_details);

    }else{

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(heightFactor:0.7,child:ShowBidsScreen(listBidings: bidings,postBidData: postBidData,));
        });
    }
  }

  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.isEmpty) {
      return Container();
    } else {
      if (postBidData.bidings!.length == 1) {
        return itemBid(postBidData.bidings![0], true, index,postBidData);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget>list = [
          itemBid(postBidData.bidings![0], false, index,postBidData),
          itemBid(postBidData.bidings![1], true, index,postBidData)];
        return Column(
          children: list,
        );
      } else {
        List<Widget>list = [
          itemBid(postBidData.bidings![0], false, index,postBidData),
          itemBid(postBidData.bidings![1], false, index,postBidData),
          itemBid(postBidData.bidings![2], true, index,postBidData)];
        return Column(
          children: list,
        );
      }
    }
  }

  Widget itemBid(Bidings bidings, bool isLast, int index, PostBidData postBidData) {
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


  Future<void> showAcceptQuoteDialog(
      BuildContext context, PostBidData postBidData, Bidings bidings) async {
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
                          Provider.of<MyBidsProvider>(context, listen: false).acceptBidSaveForm(
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

}


