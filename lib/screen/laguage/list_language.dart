import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';
import '../../model/request/language_select.dart';
import '../../route/app_routes.dart';
import '../../widgets/button.dart';

class LanguageChange extends StatefulWidget{
  const LanguageChange({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LanguageChange();
  }
}

class _LanguageChange extends State<LanguageChange>{
  List<LanaguageSelect>listLaugaes=LanaguageSelect().getLang();
  bool isLangSelect=false;
  String selectLanguage="en";

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
                      title: 'Choose a language',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:GoogleFonts.poppins().fontFamily,
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
              SizedBox(height: 24.h,),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: listLaugaes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _languageCircle(context, index);
                  },
                ),
              )
            ],

          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60.h,left: 20.w,right: 20.w),
        child: Button(isEnbale: isLangSelect,title: "Save preferred language", width: MediaQuery.of(context).size.width,height: 52.h,textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ), onClick: ()async{
          if(isLangSelect){
            S.load(Locale(selectLanguage));
            LocalSharePreferences sharePreferences=LocalSharePreferences();
            await sharePreferences.setLanguage(selectLanguage);
            Navigator.pushReplacementNamed(context, AppRoutes.intro_one);
          }else{
            ToastMessage.show(context, "Please Select the language");
          }
        },),
      ),

    );
  }



  Widget _languageCircle(BuildContext context, int index) {
    // Predefined unique border colors
    final List<Color> borderColors = [
      Colors.amber,
      Colors.teal,
      Colors.orange,
      Colors.purple,
      Colors.blue,
      Colors.indigo,
      Colors.red,
      Colors.cyan,
      Colors.green,
      Colors.deepOrange,
    ];

    final language = listLaugaes[index];
    final borderColor =  borderColors[index % borderColors.length];

    return InkWell(
      onTap: () {
        for (int i = 0; i < listLaugaes.length; i++) {
          listLaugaes[i].isSelect = false;
        }
        language.isSelect = true;
        selectLanguage = language.langCode!;
        selectLanguage=listLaugaes[index].langCode!;
        isLangSelect = true;
        setState(() {});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  color: language.isSelect!
                      ?borderColor:Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  (language.langName?.isNotEmpty ?? false)
                      ? language.langName![0] // First letter of language name
                      : '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: language.isSelect!
                        ?Colors.white:Colors.black,
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 8),
          Text(
            language.langName ?? '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}