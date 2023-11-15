import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/utils/colors.dart';
class CameraBottomsheet{
 late XFile pickedImage;

 Future<XFile> show(BuildContext context)async{
    await bottomSheet(context);
   return pickedImage;
 }

   bottomSheet(BuildContext context)async {
   await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 30,),
                Text("Select Option",style: TextStyle(color: ThemeColor.subColor,fontSize: 20.sp,fontWeight: FontWeight.w600,fontFamily: AppConstant.FONTFAMILY),),
                SizedBox(height: 20,),
                ListTile(
                  leading: new Icon(Icons.camera_alt_outlined,color: ThemeColor.theme_blue,),
                  title: new Text("Camera",style:TextStyle(color: ThemeColor.theme_blue,fontSize: 16.sp,fontWeight: FontWeight.w400,fontFamily: AppConstant.FONTFAMILY)),
                  onTap: () async{
                    pickedImage=await  callCamera();
                    Navigator.pop(context);

                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded,color:ThemeColor. theme_blue,),
                ),
                ListTile(
                  leading: new Icon(Icons.camera,color: ThemeColor.theme_blue,),
                  title: new Text("Gallery",style:TextStyle(color: ThemeColor.theme_blue,fontSize: 16.sp,fontWeight: FontWeight.w400,fontFamily: AppConstant.FONTFAMILY)),
                  onTap: () async{
                    pickedImage= await callGallery();
                    Navigator.pop(context);
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded,color: ThemeColor.theme_blue,),
                  
                ),

                SizedBox(height: 30,),

              ],
            ),
          );
        });
  }

   Future<XFile>  callCamera()async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile!;
  }

   Future<XFile> callGallery()async {
     final ImagePicker _picker = ImagePicker();
     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile!;
   }


}