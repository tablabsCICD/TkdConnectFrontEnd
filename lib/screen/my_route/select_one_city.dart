import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/my_route_provider/select_city_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../route/app_routes.dart';
import '../../widgets/button.dart';

class SelectOneCityScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectOneCityScreen();
  }
}

class _SelectOneCityScreen extends State<SelectOneCityScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          SelectCityProvider("Ideal", false, "no", "no"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Textview(
                      title: 'Add City',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              SizedBox(
                height: 16.h,
              ),
              searchBox(),
              // placesAutoCompleteTextField(),
              addRoute(context),
              listLang(),
              SizedBox(
                height: 16.h,
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60.h, left: 20.w, right: 20.w),
        child: button(),
      ),
    );
  }

  addRoute(BuildContext context) {
    return Consumer<SelectCityProvider>(
      builder: (context, provider, child) {
        return provider.listCity.isEmpty && ! provider.isLoad
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height /3,
                  child: InkWell(
                        onTap: () {
                          _showCityDialog(context,provider);
                        },
                        child: SvgPicture.asset(Images.additional_label),
                  ),
                ),
              ],
            )
            : SizedBox.shrink();
      },
    );
  }

  _showCityDialog(context,SelectCityProvider provider) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Textview(
            title: 'Add City',
            TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
          content: placesAutoCompleteTextField(),
          actions: <Widget>[
            TextButton(
              child: Textview(
                title: 'Yes',
                TextStyle(
                  color: Colors.green,
                  fontSize: 18.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                if(selectedState != null && selectedCity != null) {
                  var response = await provider.addCity(selectedState!, selectedCity!);
                  if(response == null){

                  }else{
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            TextButton(
              child: Textview(
                title: 'No',
                TextStyle(
                  color: Colors.red,
                  fontSize: 18.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  button() {
    return Consumer<SelectCityProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.isButtonEnbale,
          child: Button(
            isEnbale: provider.isButtonEnbale,
            title: "Save route",
            width: MediaQuery.of(context).size.width,
            height: 52.h,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
            onClick: () {
              provider.onClickOne(context);
            },
          ),
        );
      },
    );
  }

  TextEditingController cityController = TextEditingController();
  String? selectedCity;
  String? selectedState;

  placesAutoCompleteTextField() {

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 53.h,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.h,
                            margin: EdgeInsets.only(left: 10.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.h,
                                  child: Stack(children: [
                                    SvgPicture.asset(Images.search_normal)
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: GooglePlaceAutoCompleteTextField(
                              textEditingController: cityController,
                              googleAPIKey:
                                  "AIzaSyAm332fBuy8QoCC6ZFv7pizIqdmaT-jz30",
                              boxDecoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                              ),
                              inputDecoration: InputDecoration(
                                  hintText: "Search place",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0x662C363F),
                                    fontSize: 14.sp,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w400,
                                  )),
                              debounceTime: 400,
                              countries: ["in", "fr"],
                              isLatLngRequired: true,
                              getPlaceDetailWithLatLng:
                                  (Prediction prediction) {
                                print("placeDetails" + prediction.lat.toString());
                              },
                              itemClick: (Prediction prediction) {
                                cityController.text =
                                    prediction.description ?? "";
                                int firstIndex = cityController.text.indexOf(",");
                                List<String> parts = cityController.text.split(", ");

                                selectedCity = cityController.text.substring(0, firstIndex);
                                selectedState = parts[parts.length-2];
                                print(selectedState);
                                print("Selected City: $selectedCity");
                                print("Selected State: ${parts[parts.length-2]}");
                                print("Selected Country: ${parts[parts.length-1]}");
                                cityController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            prediction.description?.length ??
                                                0));
                              },
                              seperatedBuilder: Divider(),
                              containerHorizontalPadding: 10,

                              // OPTIONAL// If you want to customize list view item builder
                              itemBuilder:(context, index, Prediction prediction) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                          child: Text(
                                              "${prediction.description ?? ""}"))
                                    ],
                                  ),
                                );
                              },

                              isCrossBtnShown: true,

                              // default 600 ms ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 327,
                padding: const EdgeInsets.only(top: 4),
              ),
            ],
          ),
        );

  }

  searchBox() {
    return Consumer<SelectCityProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 52.h,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.h,
                            margin: EdgeInsets.only(left: 10.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.h,
                                  child: Stack(children: [
                                    SvgPicture.asset(Images.search_normal)
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: SizedBox(
                              child: TextField(
                                controller: provider.searchController,
                                onChanged: (value) {
                                  provider.searchCity(value);
                                },
                                onSubmitted: (val) async {
                                  provider.searchCity(val);
                                },
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "Search place",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0x662C363F),
                                      fontSize: 14.sp,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w400,
                                    )),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 327,
                padding: const EdgeInsets.only(top: 4),
              ),
            ],
          ),
        );
      },
    );
  }

  laguagesList(int index, SelectCityProvider provider) {
    return InkWell(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }

        provider.selectOneCity(index, context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.w),
        decoration: BoxDecoration(
          color: provider.listCity[index].isSelect
              ? ThemeColor.select_green
              : ThemeColor.white,
          border: Border(
            bottom: BorderSide(width: 0.50, color: Color(0x332C363F)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: Text(
                  provider.listCity[index].name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            provider.listCity[index].isSelect
                ? SvgPicture.asset(
                    Images.green_tick,
                    height: 24.h,
                    width: 24.w,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  selectTab() {
    return Consumer<SelectCityProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 327.w,
          height: 32.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0x332C363F),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.50.w, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.selectTab("Start");
                  },
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: ShapeDecoration(
                      color: provider.isSelectStartLocation
                          ? Colors.white
                          : Color(0x19001E49),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0x332C363F)),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Start location',
                          style: TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.selectTab("Des");
                  },
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: ShapeDecoration(
                      color: provider.isSelectDestination
                          ? Colors.white
                          : Color(0x19001E49),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0x332C363F)),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Destination',
                          style: TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  listLang() {
    return Consumer<SelectCityProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              controller: provider.scrollController,
              itemCount: provider.listCity.length,
              itemBuilder: (BuildContext context, int index) {
                return laguagesList(index, provider);
              }),
        );
      },
    );
  }
}
