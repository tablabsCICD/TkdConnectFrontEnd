import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/widgets/button.dart';
import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../provider/dashboard/post_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/editText.dart';
import '../my_route/select_one_city.dart';

class PostVehicleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostVehicleScreen();
  }
}

class _PostVehicleScreen extends State<PostVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PostLoadProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                // SvgPicture.asset(
                //   Images.vehicle_load,
                //   height: 133.h,
                //   width: 200.w,
                // ),
                labelText(S().vehicle+" "+S().loads),
                SizedBox(
                  height: 4.h,
                ),
                DropDown(
                  onClick: () async {
                    ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                    int a = await itemBottomSheet.showIteam(context, provider.reqirementVehicale, "Select Load Type");
                    provider.selectedRequrimentVehicaleType(a);
                  },
                  hint: provider.selectedRequriment,
                ),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().fromCity),
                SizedBox(
                  height: 4.h,
                ),
                DropDown(
                  onClick: () async {
                    RouteRequest routeRequest = await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.9, child: SelectOneCityScreen());
                        });
                    provider.selectedSourceCity(routeRequest.startLocation);
                  },
                  hint: provider.sourceCity,
                ),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().toCity),
                SizedBox(
                  height: 4.h,
                ),
                DropDown(
                  onClick: () async {
                    RouteRequest routeRequest = await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.9, child: SelectOneCityScreen());
                        });
                    provider.selectedDestinationCity(routeRequest.startLocation);
                  },
                  hint: provider.destinationCity,
                ),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().cargoType),
                SizedBox(
                  height: 4.h,
                ),
                DropDown(
                  onClick: () async {
                    ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                    int a = await itemBottomSheet.showIteam(
                        context, provider.cargoList, "Select Cargo Type");
                    provider.selectedCargoType(a);
                  },
                  hint: provider.selectedCargo,
                ),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().vehicleSize),
                SizedBox(
                  height: 4.h,
                ),
                editViewError("eg.100",provider.vehicleSizeController,provider,provider.vehicaleSize),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().loadWeight),
                SizedBox(
                  height: 4.h,
                ),
                editViewError("In Tons",provider.loadWeightController,provider,provider.loadWieght),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().mobileNumber),
                SizedBox(
                  height: 4.h,
                ),
                editView("eg.88XXXXXX90",provider.mobileNumberController,provider,true),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().email_id),
                SizedBox(
                  height: 4.h,
                ),
                editView("eg.abc@gmail.com",provider.emailIdController,provider,true),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().specialInstruction),
                SizedBox(
                  height: 4.h,
                ),
                editView("eg.",provider.specialInstructionController,provider,false),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().paymentType),
                SizedBox(
                  height: 4.h,
                ),
                DropDown(
                  onClick: () async {
                    ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                    int a = await itemBottomSheet.showIteam(
                        context,provider.paymentList, "Select Payment Type");
                    provider.selectedPaymentType(a);
                  },
                  hint: provider.selectedPayment,
                ),
                SizedBox(
                  height: 12.h,
                ),
                dnd(context),
                SizedBox(
                  height: 12.h,
                ),
                hideMyIden(context),
                SizedBox(
                  height: 30.h,
                ),
                provider.images.length>0? BaseWidget().carouseImageDelete(provider.images,(item){
                  provider.images.remove(item);
                  provider.notifyListeners();
                }
                ):SizedBox(),
                SizedBox(
                  height: 44.h,
                ),
                InkWell(
                    onTap: () {
                      provider.uploadImage(context);
                    },
                    child: SvgPicture.asset(Images.add_image)),
                Text(
                  S().addImagesAt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF001E49),
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 20.h),
                  child: Button(width: MediaQuery.of(context).size.width, height: 49.h, title: S().postLoad, textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,

                  ), onClick: (){
                    provider.checkVehicaleValidation(context);
                  },isEnbale: true,),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  labelText(String label) {
    return Container(
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

  editView(String hint,TextEditingController controller,PostLoadProvider provider,bool redOnly) {
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val){
        provider.enble();
      },
    );
  }


  editViewError(String hint,TextEditingController controller,PostLoadProvider provider,bool valid) {
    return EditTextError(
      validate: valid,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val){
        provider.enble();
      },
    );
  }


  dnd(context){
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 33.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "DND",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: AppConstant.FONTFAMILY,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Color(0x99001E49),
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
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
              const SizedBox(width: 129),
              Container(
                width: 100.w,
                height: 40.sp,
                child:Switch.adaptive(
                  // This bool value toggles the switch.
                  value: provider.dnd,
                  splashRadius: 10,
                  activeColor: ThemeColor.theme_blue,
                  onChanged: (bool value) {
                    provider.dndChange(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  hideMyIden(context){
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 33.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Hide my identity",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: AppConstant.FONTFAMILY,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Color(0x99001E49),
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
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

              Container(
                width: 100.w,
                height: 40.sp,
                child:Switch.adaptive(
                  // This bool value toggles the switch.
                  value: provider.hideMyID,
                  splashRadius: 10,
                  activeColor: ThemeColor.theme_blue,
                  onChanged: (bool value) {
                    provider.hideMyId(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}