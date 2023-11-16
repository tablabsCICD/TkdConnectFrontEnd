import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/dashboard/genral_post_provider.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../provider/dashboard/post_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/editText.dart';


class PostGenralScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _PostGenralScreen();
  }

}
class _PostGenralScreen extends State<PostGenralScreen>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GenralPostProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<GenralPostProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SvgPicture.asset(
                  Images.general_post,
                  height: 133.h,
                  width: 200.w,
                ),

                labelText(S().title),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egTitleofPost,provider.vehicleSizeController,provider),
                SizedBox(
                  height: 12.h,
                ),
                labelText(S().subtitle),
                SizedBox(
                  height: 4.h,
                ),
                editView(S().egSubTitle,provider.loadWeightController,provider),
                SizedBox(
                  height: 12.h,
                ),

                provider.images.length>0? BaseWidget().carouseImage(provider.images):SizedBox(),
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
                  child: Button(width: MediaQuery.of(context).size.width, height: 49.h, title: S().post, textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,

                  ), onClick: (){
                    provider.createPost(context);
                  },isEnbale: provider.enbleButton,),
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

  editView(String hint,TextEditingController controller,GenralPostProvider provider) {
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

}