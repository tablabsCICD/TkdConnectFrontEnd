import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../model/response/search_data.dart';
import '../../provider/message/message_provider.dart';
import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageScreenState();
  }
}

class _MessageScreenState extends State<MessageScreen> {

  @override
  void dispose() {
    // TODO: implement dispose
    _myProvider.stopTimer();
    super.dispose();

  }
 late MessageProvider _myProvider;

  @override
  void initState() {
    // TODO: implement initState
    _myProvider=MessageProvider();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myProvider,
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            top_bar(context),
            serachBar(),
            toptabBar(),

            Consumer<MessageProvider>(
              builder: (context, provider, child) {
                return Visibility(
                    visible:provider.userChat.isEmpty, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 200.h,),
                    const Center(child: Text("Please search the user and start the connection"),),

                  ],
                ));
              },
            ),

            userChat(),



            Consumer<MessageProvider>(
              builder: (context, provider, child) {
                return Visibility(
                    visible: !provider.isUserVisbile, child: userSearch());
              },
            ),


          ],
        ),
      ),
    );
  }

  top_bar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 87.h,
      //padding: const EdgeInsets.only(bottom: 16),
      decoration: const ShapeDecoration(
        color: Color(0xFFC3262C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: const SizedBox(),
    );
  }

  serachBar() {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Transform.translate(
          // e.g: vertical negative margin
            offset: const Offset(00,-25),
       child: Container(
           // transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
            margin: EdgeInsets.only(right: 20.w, left: 20.w),
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
                      side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                                  SizedBox(
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
                                    provider.searchUser(value);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Search users ",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: const Color(0x662C363F),
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

              ],
            ),
          ),
        );
      },
    );
  }

  userSearch() {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView.builder(

                itemCount: provider.userSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  return itemMessageSearch(provider.userSearch[index]);
                }),
          ),
        );
      },
    );
  }

  userChat() {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.isUserVisbile,
          child: Container(
            child: Expanded(
              child: ListView.builder(
                  itemCount: provider.userChat.length,
                  itemBuilder: (BuildContext context, int index) {
                    return itemMessageChat(provider.userChat[index]);
                  }),
            ),
          ),
        );
      },
    );
  }

  toptabBar() {
    return Consumer<MessageProvider>(
  builder: (context, provider, child) {
  return InkWell(
      onTap: (){
          provider.getChatList();
      },
      child: Container(
        width: 335.w,
        height: 32.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0x332C363F),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const ShapeDecoration(
                  color: Color(0x19001E49),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'All messages',
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  },
);
  }

  itemMessage() {
    return Container(
      width: 375.w,
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0x192C363F)),
          top: BorderSide(color: Color(0x192C363F)),
          right: BorderSide(color: Color(0x192C363F)),
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 33.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: const Color(0x14001E49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   left: 4.w,
                              //   top: 2.h,
                              //   child: Text(
                              //     'RS',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Color(0xFFC3262C),
                              //       fontSize: 18,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w600,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              // Positioned(
                              //   left: -0.80,
                              //   top: -6.40,
                              //   child: Container(
                              //     height: 48.80.h,
                              //     padding: const EdgeInsets.only(top: 4, left: 0.80, right: 1.60),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //           width: 32.w,
                              //           height: 44.80.h,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //               image: NetworkImage("https://via.placeholder.com/32x45"),
                              //               fit: BoxFit.fill,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              BaseWidget()
                                  .getImage("", height: 32.h, width: 32.w)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Dileepa BM',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Lorem ipsum dolor sit amet',
                            style: TextStyle(
                              color: Color(0x99001E49),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 129),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '15:21',
                  style: TextStyle(
                    color: Color(0xFFC3262C),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: const Color(0xFFC3262C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '15',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  itemMessageSearch(SearchData data) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            provider.postChatAdded(data, context);

          },
          child: Container(
            width: 375.w,
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Color(0x192C363F)),
                top: BorderSide(color: Color(0x192C363F)),
                right: BorderSide(color: Color(0x192C363F)),
                bottom: BorderSide(width: 1, color: Color(0x192C363F)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 33.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: ShapeDecoration(
                            color: const Color(0x14001E49),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    BaseWidget().getImage("${data.companyLogo}",
                                        height: 32.h, width: 32.w)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${data.firstName!} ${data.lastName!}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontFamily: AppConstant.FONTFAMILY,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 129),

              ],
            ),
          ),
        );
      },
    );
  }

  itemMessageChat(userAdded data) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  arguments: ChatPageArguments(
                    id: data.id,
                    peerId: data.userId,
                    peerAvatar: data.profile,
                    peerNickname: data.name,
                    notificationId: data.notificationUserId
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: 375.w,
           // height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Color(0x192C363F)),
                top: BorderSide(color: Color(0x192C363F)),
                right: BorderSide(color: Color(0x192C363F)),
                bottom: BorderSide(width: 1, color: Color(0x192C363F)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                   // height: 33.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: ShapeDecoration(
                            color: const Color(0x14001E49),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    BaseWidget().getImage(data.profile,
                                        height: 32.h, width: 32.w)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          data.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontFamily: AppConstant.FONTFAMILY,
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 129),

              ],
            ),
          ),
        );
      },
    );
  }


}
