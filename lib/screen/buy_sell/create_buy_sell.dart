import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/buy_sell_provider/create_buy_sell_provider.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/editText.dart';
import '../my_route/select_one_city.dart';

class CreateBuySell extends StatelessWidget {
  const CreateBuySell({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreateBuySellProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<CreateBuySellProvider>(
        builder: (context, provider, child) {
          return Container(
              child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              BaseWidget().appBar(context, "Post Buy/Sell",isSearch:false),
              Expanded(
                  child: ListView(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    labelText(S().buySell),
                    SizedBox(
                      height: 4.h,
                    ),
                    DropDown(
                      onClick: () async {
                        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                        int a = await itemBottomSheet.showIteam(
                            context, provider.reqirement, S().selectOne);
                        provider.selectedRequrimentType(a);
                      },
                      hint: provider.selectedRequriment,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText(S().companyName),
                    SizedBox(
                      height: 4.h,
                    ),
                    editView("eg.TKD", provider.companyNameController, provider,
                        true),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText(S().mobileNumber),
                    SizedBox(
                      height: 4.h,
                    ),
                    editView("eg.88XXXXXX90", provider.mobileNumberController,
                        provider, true),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText(S().email_id),
                    SizedBox(
                      height: 4.h,
                    ),
                    editView("eg.abc@gmail.com", provider.emailIdController,
                        provider, true),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Select City"),
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
                                  heightFactor: 0.9,
                                  child: SelectOneCityScreen());
                            });
                        provider.selectedDestinationCity(
                            routeRequest.startLocation);
                      },
                      hint: provider.destinationCity,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Select Maker Name"),
                    SizedBox(
                      height: 4.h,
                    ),
                    DropDown(
                      onClick: () async {
                        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                        int a = await itemBottomSheet.showIteam(
                            context, provider.makerList, S().selectOne);
                        provider.selectedMakerType(a);
                      },
                      hint: provider.selectedMakerName,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Model Name"),
                    SizedBox(
                      height: 4.h,
                    ),
                    editViewError("eg.Tata SCV", provider.modelName, provider,
                        provider.isModelName),
                    SizedBox(
                      height: 12.h,
                    ),
                    Visibility(
                        visible: provider.isSellSelected,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12.h,
                            ),
                            labelText("Kilometer driven"),
                            SizedBox(
                              height: 4.h,
                            ),
                            editViewError("eg.5000 Km", provider.kiloMeter,
                                provider, provider.isKilo),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                        )),
                    Visibility(
                        visible: provider.isSellSelected,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12.h,
                            ),
                            labelText("Register Number"),
                            SizedBox(
                              height: 4.h,
                            ),
                            editViewError("eg.MH09 EG 0000",
                                provider.vehicleRno, provider, provider.isrlNo),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                        )),
                    labelText("Select Manufacturing Year"),
                    SizedBox(
                      height: 4.h,
                    ),
                    DropDown(
                      onClick: () async {
                        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                        int a = await itemBottomSheet.showIteam(
                            context, provider.yearList, S().selectOne);
                        provider.selectedyearType(a);
                      },
                      hint: provider.selectedYear,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Vehicle Size"),
                    SizedBox(
                      height: 4.h,
                    ),
                    DropDown(
                      onClick: () async {
                        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                        int a = await itemBottomSheet.showIteam(
                            context, provider.vehicleSizeList, S().selectOne);
                        provider.selectedvehicleSizeType(a);
                      },
                      hint: provider.selectedVehicleSize,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Condition Of Vehicle"),
                    SizedBox(
                      height: 4.h,
                    ),
                    DropDown(
                      onClick: () async {
                        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                        int a = await itemBottomSheet.showIteam(
                            context, provider.conditionList, S().selectOne);
                        provider.selectedConditionType(a);
                      },
                      hint: provider.selectedCondition,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Approx prise"),
                    SizedBox(
                      height: 4.h,
                    ),
                    editViewErrorNumber(
                        "eg.1000", provider.price, provider, provider.isPrise),
                    SizedBox(
                      height: 12.h,
                    ),
                    labelText("Additional Info"),
                    SizedBox(
                      height: 4.h,
                    ),
                    editView("eg.Info", provider.specialInstructionController,
                        provider, false),
                    SizedBox(
                      height: 12.h,
                    ),
                    provider.images.isNotEmpty
                        ? Visibility(
                      visible: provider.isSellSelected,
                          child: BaseWidget().carouseImageDelete(provider.images,
                              (item) {
                              provider.images.remove(item);
                              provider.notifyListeners();
                            }),
                        )
                        : const SizedBox(),
                    Visibility(
                      visible: provider.isSellSelected,
                      child: SizedBox(
                        height: 44.h,
                      ),
                    ),
                    Visibility(
                      visible: provider.isSellSelected,
                      child: InkWell(
                          onTap: () {
                            provider.uploadImage(context);
                          },
                          child: SvgPicture.asset(Images.add_image)),
                    ),
                    Visibility(
                       visible:  provider.isSellSelected,
                      child: Text(
                        S().addImagesAt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF001E49),
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]))
            ],
          ));
        },
      ),
      bottomNavigationBar: Consumer<CreateBuySellProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
            child: Button(
              width: MediaQuery.of(context).size.width,
              height: 49.h,
              title: "Post Buy/Sell",
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
              onClick: () {
                provider.checkValidation(context);
              },
              isEnbale: true,
            ),
          );
        },
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

  editView(String hint, TextEditingController controller,
      CreateBuySellProvider provider, bool redOnly) {
    return EditText(
      readOnly: redOnly,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        // provider.enble();
      },
    );
  }

  editViewError(String hint, TextEditingController controller,
      CreateBuySellProvider provider, bool valid) {
    return EditTextError(
      validate: valid,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        // provider.enble();
      },
    );
  }

  editViewErrorNumber(
    String hint,
    TextEditingController controller,
    CreateBuySellProvider provider,
    bool valid,
  ) {
    return EditTextError(
      validate: valid,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      keybordType: TextInputType.number,
      onChange: (val) {
        // provider.enble();
      },
    );
  }
}
