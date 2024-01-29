import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:intl/intl.dart';
import 'package:tkd_connect/provider/dashboard/comment_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../widgets/textview.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          CommentProvider(context, widget.truckLoad.id!),
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
              child: Consumer<CommentProvider>(
                builder: (context, provider, child) {
                  return

                    RefreshIndicator(
                    onRefresh: () async {
                      provider.selectedPage = 0;
                      provider.getCommentByPostId(
                          context, widget.truckLoad.id!);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        generalPost(widget.truckLoad),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(top: 12.h, left: 16.w),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r)),
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
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                       Expanded(
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(12.r),
                            child: !provider.isLoading && provider.commentList.length==0?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("No any Comment")
                              ],
                            ) :ListView.builder(
                              shrinkWrap: true,
                              controller: provider.scrollController,
                              itemCount: provider.commentList.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    ListTile(
                                      //leading: getImage("${generalPost.images==[]?'':generalPost.images![0]}"),

                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BaseWidget().getImageclip(
                                              provider
                                                  .commentList[i].profileImage!,
                                              height: 20.h,
                                              width: 20.w),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Textview(
                                                title: provider
                                                    .commentList[i].userName!,
                                                TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.sp,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${provider.commentList[i].comment}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff1f1f1f),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        "${readTimestamp(provider.commentList[i].date!)}",
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff1f1f1f),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 0.2,
                                      thickness: 0.5,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: ThemeColor.baground,
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
                                      color: ThemeColor.red,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w300),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        provider.createCommentApi(
                                            widget.truckLoad.id!,
                                            provider.commentController.text);
                                      },
                                      child: Icon(
                                        Icons.send,
                                        color: ThemeColor.red,
                                      ))),
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

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm ');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  generalPost(TruckLoad truckLoad) {
    return Container(
      width: 335.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
              onTap: () {
                String des = truckLoad.topicName! + "\n " + truckLoad.content!;
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
              child: BaseWidget().profile(truckLoad.companyLogo!,
                  truckLoad.nameOfPerson!, truckLoad.companyName!,
                  verify: truckLoad.isPaid!)),
          // SizedBox(
          //   height: 12.h,
          // ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget()
                  .heading(truckLoad.topicName!, "", truckLoad.content!)),
          SizedBox(
            height: 5.h,
          ),

          imagePost(truckLoad),
        ],
      ),
    );
  }

  imagePost(TruckLoad load) {
    if (load.postImages!.length == 0) {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
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
                  child: BaseWidget().likeCommentDetails(
                      likeCount: provider.countLike,
                      commentCount: provider.countComment,
                      load,
                      context,(){
                    provider.likeIncreamentApi(load.id!, context);
                  })),
            ],
          );
        },
      );
    } else if (load.postImages!.length == 1) {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              BaseWidget().image(image: load.postImages!.first),
              SizedBox(
                height: 9.h,
              ),
              Container(
                  //transform: Matrix4.translationValues(0.0, -5.0.h, 00),
                  child: BaseWidget().likeCommentDetails(
                      likeCount: provider.countLike,
                      commentCount: provider.countComment,
                      load,
                      context,(){
                    provider.likeIncreamentApi(load.id!, context);
                  }))
            ],
          );
        },
      );
    } else {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                  transform: Matrix4.translationValues(0.0, -25.0.h, 00),
                  child: BaseWidget()
                      .carouseImage(new List<String>.from(load.postImages!))),
              SizedBox(
                height: 9.h,
              ),
              Container(
                  transform: Matrix4.translationValues(0.0, -10.0.h, 00),
                  child: BaseWidget().likeCommentDetails(
                      likeCount: provider.countLike, commentCount: provider.countComment, load, context,(){

                        provider.likeIncreamentApi(load.id!, context);
                  }))
            ],
          );
        },
      );
    }
  }
}
