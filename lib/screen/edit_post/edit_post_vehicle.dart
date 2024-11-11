import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/my_post_bid_list.dart';
import 'package:tkd_connect/provider/dashboard/edit_post_provider.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/datepicker.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../utils/colors.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/editText.dart';
import '../my_route/select_one_city.dart';

class EditPostVehicleScreen extends StatefulWidget {
  PostBidData postBidData;
  EditPostVehicleScreen(this.postBidData, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditPostVehicleScreen();
  }
}

class _EditPostVehicleScreen extends State<EditPostVehicleScreen> {
  ScrollController horizantalControllet = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EditPostLoadProvider(widget.postBidData),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<EditPostLoadProvider>(
      builder: (context, provider, child) {
        getAddedUserList(provider);
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
                labelText("${S().vehicle} ${S().loads}"),
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
                          return const FractionallySizedBox(
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
                          return const FractionallySizedBox(
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
                labelText(S().expiryDate),
                SizedBox(
                  height: 4.h,
                ),
                _buildText(context,"dd/mm/yyyy",provider.expiryDateController, provider,true),
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
                  height: 12.h,
                ),
                labelText(S().groupType),
                SizedBox(
                  height: 4.h,
                ),
               /* DropDown(
                  onClick: () async {
                    ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                    int index = await itemBottomSheet.showIteam(
                        context,provider.listOptionShow, provider.selectOption);
                    provider.selecteOptiontoShow(index,context);
                  },
                  hint: provider.selectedGroup,
                ),*/
                Visibility(
                  visible: provider.addedUserListIdInPost.isEmpty ? false : true,
                  child: Container(
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            child: selectedUsers(),
                            height: 60.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                provider.images.isNotEmpty? BaseWidget().carouseImageDelete(provider.images,(item){
                  provider.images.remove(item);
                  provider.notifyListeners();
                }
                ):const SizedBox(),
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
                    color: const Color(0xFF001E49),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Post Load',style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),),
                          content: Text('Are you sure you want to post this requirement?',style: TextStyle(
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
                              child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,),),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.checkVehicaleValidation(context);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.green, fontSize: 12.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    // provider.checkVehicaleValidation(context);
                  },isEnbale: true,),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  selectedUsers() {
    return Consumer<EditPostLoadProvider>(
      builder: (context, model, child) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: horizantalControllet,
          itemCount: model.addedUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 50.h,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  children: <Widget>[
                    BaseWidget().getImageclip(
                      model.addedUsers[index].profilePicture.toString(),
                      height: 34,
                      width: 34,
                    ),
                    Text(
                      model.addedUsers[index].firstName!,
                      style: TextStyle(
                        color: const Color(0xCC001E49),
                        fontSize: 14.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            );}
      ),
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

  editView(String hint,TextEditingController controller,EditPostLoadProvider provider,bool redOnly) {
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


  editViewError(String hint,TextEditingController controller,EditPostLoadProvider provider,bool valid) {
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
    return Consumer<EditPostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
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
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Do Not Disturb",
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
                              const SizedBox(
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
              SizedBox(
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
    return Consumer<EditPostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
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
                              SizedBox(
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
                              const SizedBox(
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

              SizedBox(
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

  Future<void> getAddedUserList(EditPostLoadProvider provider) async {
    await provider.getUserListFromString(widget.postBidData.genericCardsDto!.userList!);
  }

  Widget _buildText(context,String hint,TextEditingController controller,EditPostLoadProvider provider,bool redOnly) {
    return EditText(
      readOnly: true,
      width: 335.w,
      height: 52.h,
      hint: "dd/mm/yyyy",
      controller: controller,
      onTap: () async {
        String Date =
        await DateTimePickerDialog().pickDateDialog(
            context);
        provider.setDate(Date);
      },
    );}

}