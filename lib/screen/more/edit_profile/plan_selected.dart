import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/edit_profile/edit_profile_provider.dart';
import 'package:tkd_connect/screen/kyc/kyc_screen_one.dart';

import '../../../constant/images.dart';
import '../../../widgets/plan_widget.dart';

class SelectPlanScreenEdit extends StatefulWidget{

   EditProfileProvider provider;

   SelectPlanScreenEdit({super.key, required this.provider});

  @override
  State<StatefulWidget> createState() {
    return _SelectPlanScreen();
  }
}

class _SelectPlanScreen extends State<SelectPlanScreenEdit>{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EditProfileProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }
  _buildPage(BuildContext context){
    return Consumer<EditProfileProvider>(
  builder: (context, provider, child) {
  return Container(

      margin: EdgeInsets.only(left: 20.w,right: 20.w),
      child: Column(

          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            SizedBox(height: 28.h,),
            PlanWidget(isSelected: true, title: 'Clear pearl', amount: '0', image: Images.pearls, subtitle: 'CURRENT PLAN',),
            SizedBox(height: 12.h,),
            PlanWidget(isSelected: false, title: 'Blue pearl', amount: '299', image: Images.pearls_blue,subtitle: 'RECOMMENDED'),
            SizedBox(height: 12.h,),
            PlanWidget(isSelected: false, title: 'Red pearl', amount: '349', image: Images.pearls_red,subtitle: 'No'),
            SizedBox(height: 12.h,), PlanWidget(isSelected: false, title: 'Black pearl', amount: '449', image: Images.pearls_black,subtitle: 'No'),
            SizedBox(height: 161.h,)


          ]

      ),

    );
  },
);
  }
  void showBootomSheet() {

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(heightFactor:0.7,child: KYCScreenOne());
        });

  }






}