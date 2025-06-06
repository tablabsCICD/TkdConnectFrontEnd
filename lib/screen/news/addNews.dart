import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/news/news_provider.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../provider/incident/report_incident_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/datepicker.dart';
import '../../widgets/editText.dart';

class AddNewsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NewsProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add News",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color(0xFFC3262C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              labelText("News Title",isMandatory: true),
              SizedBox(
                height: 4.h,
              ),
              editViewError(
                  "enter title", provider.topicController, provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("Description"),
              SizedBox(
                height: 4.h,
              ),
              editViewError("short description", provider.descriptionController,
                  provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("News Link"),
              SizedBox(
                height: 4.h,
              ),
              editViewError(
                  "youtube link/google link", provider.linkController, provider, true),
              SizedBox(
                height: 12.h,
              ),
              _buildProofUploader(provider, context),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Button(
                  width: MediaQuery.of(context).size.width,
                  height: 49.h,
                  title: S().addNews,
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
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProofUploader(
      NewsProvider provider, BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          labelText(
            "Upload Photo",
           isMandatory: true,
          ),
          provider.images.isNotEmpty
              ? BaseWidget().carouseImageDelete(provider.images, (item) {
            provider.images.remove(item);
            provider.notifyListeners();
          })
              : const SizedBox(),
          SizedBox(
            height: 16.h,
          ),
          InkWell(
              onTap: () {
                provider.uploadImage(context);
              },
              child: SvgPicture.asset(Images.add_image)),
          Text(
            "Upload Images",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF001E49),
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  labelText(String label, {bool isMandatory = false}) {
    return SizedBox(
      width: 332.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),
              children: isMandatory
                  ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: ThemeColor.secondary_color,
                    fontSize: 12.sp,
                  ),
                ),
              ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
  editView(String hint, TextEditingController controller,
      NewsProvider provider, bool redOnly) {
    return EditText(
      readOnly: redOnly,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        provider.enble();
      },
    );
  }

  editViewError(String hint, TextEditingController controller,
      NewsProvider provider, bool valid) {
    return EditTextError(
      validate: valid,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        provider.enble();
      },
    );
  }
}
