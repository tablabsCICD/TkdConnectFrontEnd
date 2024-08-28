import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/notification/local_notification.dart';
import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../provider/bulkupload/bulkuploadprovider.dart';
import '../../utils/colors.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/button.dart';
import '../../widgets/drop_down.dart';

class BulkUploadLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => BulkUploadProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor:ThemeColor.baground,
      body: Consumer<BulkUploadProvider>(
  builder: (context, provider, child) {
  return SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),

            ApplicationAppBar().appBarWithBack(context, S().bulkLoadUpload),
            SizedBox(height: 40,),
            tabs(),

            SizedBox(height: 10,),

            labelText(S().showPostto),
            SizedBox(
              height: 4.h,
            ),

            DropDown(
              onClick: () async {

                ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                int index = await itemBottomSheet.showIteam(
                    context,provider.listOptionShow, provider.selectOption);
                provider.selecteOptiontoShow(index,context);
              },
              hint: provider.selectedGroup,
            ),

            SizedBox(height: 40,),
            InkWell(onTap:(){
              provider.selectFile(context);
            },child: SvgPicture.asset(Images.add_image)),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                downloadFile();

              },
              child: Text(
                S().downloadExl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColor.red,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            SizedBox(height: 40,),
            SizedBox(height: 20,),
            Padding(
              padding:  EdgeInsets.only(bottom: 20.h,left: 20,right: 20),
              child: Button(width: MediaQuery.of(context).size.width, height: 49.h, title: S().uploadLoad, textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ), onClick: (){

                provider.selectFile(context);


              },isEnbale: true,),
            )
          ],

        ),
      );
  },
),


    );

  }





  Future<void> downloadFile() async {
    try {
      // Get the app's document directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/full_truck_load_-_Copy.xls';

      // Create a Dio instance
      Dio dio = Dio();

      // Download the file
      await dio.download("https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1724739670774-full_truck_load_-_Copy.xlsx", filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          // Print the progress
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
      LocalNotificationService.localNotification();
      OpenFile.open(directory.path);
      print('File downloaded to $filePath');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  // Future<void> _checkPermission() async {
  //   final status = await Permission.storage.request();
  //   if (status != PermissionStatus.granted) {
  //     // Handle the case when permission is not granted
  //     print('Storage permission is not granted');
  //   }
  // }


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


  tabs(){
    return Consumer<BulkUploadProvider>(
  builder: (context, provider, child) {
  return Container(
      width: 335.w,
      height: 32.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.75, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabItem(provider.isLoad,S().loads,(){

           provider.isLoad=true;
           provider.changeTab();


          }),
          AppConstant.USERTYPE==AppConstant.TRANSPOTER || AppConstant.AGENT==AppConstant.USERTYPE || AppConstant.MANUFACTURE==AppConstant.USERTYPE ?   tabItem(!provider.isLoad,S().vehicle,(){

            provider.isLoad=false;
            provider.changeTab();

          }):const SizedBox(),


        ],
      ),
    );
  },
);
  }


  tabItem(bool isSelect,String title,Function onClick){
    return  Expanded(
      child: InkWell(
        onTap: (){
          onClick();
        },
        child: Container(
          height: double.infinity,
          // padding:  EdgeInsets.symmetric(horizontal: 12.h),
          decoration: ShapeDecoration(
            color: isSelect?ThemeColor.theme_blue:ThemeColor.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isSelect?const Color(0x332C363F):ThemeColor.white),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelect?ThemeColor.progress_color:ThemeColor.subColor,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: isSelect?FontWeight.w600:FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}



