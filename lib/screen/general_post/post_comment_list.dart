import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/general_post_model.dart';
import 'package:tkd_connect/model/response/job_list.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:tkd_connect/provider/general_post/general_post_provider.dart';
import 'package:tkd_connect/provider/jobs/job_list_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../route/app_routes.dart';

class PostCommentList extends StatefulWidget {

  TruckLoad truckLoad;
  PostCommentList(this.truckLoad);

  @override
  State<StatefulWidget> createState() {
    return _PostCommentListState();
  }
}

class _PostCommentListState extends State<PostCommentList> {


  @override
  Widget build(BuildContext context) {
    Provider.of<HomeScreenProvider>(context).getCommentByPostId(context, widget.truckLoad.id!);
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeScreenProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                BaseWidget().appBarSearchFilter(context, "Comments"),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: Consumer<HomeScreenProvider>(
                    builder: (context, provider, child) {
                      return RefreshIndicator(
                        onRefresh: ()async{
                          provider.selectedPage=0;
                          provider.getCommentByPostId(context, widget.truckLoad.id!);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            generalPost(widget.truckLoad),
                            SizedBox(height: 10.h,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top:12.h,left: 16.w),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r),topRight: Radius.circular(16.r)),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x114A5568),
                                blurRadius: 8.r,
                                offset: Offset(0, 3),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Text('Comments', style: TextStyle(
                            fontSize:18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                          ),),
                        ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(12.r),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: provider.scrollController,
                                  itemCount: provider.commentList.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          //leading: getImage("${generalPost.images==[]?'':generalPost.images![0]}"),
                                          title: Text(
                                            "${provider.commentList[i].comment}",
                                            style: TextStyle(
                                              fontSize:15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${provider.commentList[i].date}",
                                            style: TextStyle(
                                              fontSize:15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff818080),
                                            ),
                                          ),
                                        ),
                                        Divider(height: 0.2,thickness: 0.2,)
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 90.h,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: provider.commentController,
                                  style: TextStyle(
                                    color: Color(0xff1B1B1B),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Add a comment..",
                                    hintStyle: TextStyle(
                                        color: Color(0xffcccccc),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        bool result = provider.createCommentApi(widget.truckLoad.id!,provider.commentController.text);
                                        if(result){
                                          provider.commentController.clear();
                                        }else{
                                          print("error");
                                        }
                                      },
                                        child: Icon(Icons.send)
                                    )
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )),

    );
  }


  generalPost(TruckLoad truckLoad) {
    return Container(
      width: 335.w,
      margin: EdgeInsets.symmetric(horizontal:20.w),
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: (){
                String des=truckLoad.topicName!+"\n "+truckLoad.content!;
                Utils().callShareFunction(des);
              },
              child: Container(
                width: 38.w,
                height: 38.h,
                child: SvgPicture.asset(
                  Images.share_icon,
                  height: 38.h,
                  width: 38.w,
                ),
              ),
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().profile(truckLoad.companyLogo!, truckLoad.nameOfPerson!, truckLoad.companyName!,verify: truckLoad.isPaid!)),
          // SizedBox(
          //   height: 12.h,
          // ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().heading(truckLoad.topicName!, "", truckLoad.content!)),
          SizedBox(
            height: 5.h,
          ),

          imagePost(truckLoad),

        ],
      ),
    );
  }

  imagePost(TruckLoad load){
    if(load.postImages!.length==0){
      return    Column(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -20.0.h, 00),
            width: 311.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 311.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50.w,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0x332C363F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load)),
        ],
      );
    }else if(load.postImages!.length==1){
      return Column(
        children: [
          BaseWidget().image(image: load.postImages!.first),
          SizedBox(
            height: 9.h,
          ),
          Container(
            //transform: Matrix4.translationValues(0.0, -5.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load))
        ],
      );
    }else{

      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().carouseImage(new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9.h,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load))
        ],
      );
    }

  }



}
