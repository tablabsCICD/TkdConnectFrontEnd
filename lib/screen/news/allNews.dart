import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/news/news_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/allNewsResponse.dart';
import '../../model/response/transport_directory_search.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/card/dashboard_cards.dart';
import '../../widgets/textview.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllNewsScreenState();
  }
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NewsProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  User? user;

  getUser() async {
    user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
  }
  _buildPage(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: true,
        child: InkWell(
          onTap: () async {
            await Navigator.pushNamed(context, AppRoutes.addNews);
          },
          child: Container(
            width: 155.w,
            height: 38.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            decoration: ShapeDecoration(
              color: ThemeColor.theme_blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S().addNews,
                  style: TextStyle(
                    color: ThemeColor.progress_color,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: Stack(children: [
                          SvgPicture.asset(
                            Images.add,
                            height: 16.h,
                            width: 16.w,
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          return Container(
            color: ThemeColor.baground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                top_bar(context, provider),
                SizedBox(
                  height: 16.h,
                ),
                allNewsTag(provider),
                provider.allNews.isEmpty && provider.isLoadDone
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(S().noRecordFound),
                      ))
                    : const SizedBox(),
                allNewsData()
              ],
            ),
          );
        },
      ),
    );
  }

  allNewsData() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              controller: provider.scrollControllerVertical,
              itemCount: provider.allNews.length,
              itemBuilder: (BuildContext context, int index) {
                return newsItem(provider.allNews[index]);
              }),
        );
      },
    );
  }

  top_bar(BuildContext context, provider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 87.h,
      decoration: const ShapeDecoration(
        color: Color(0xFFC3262C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: searchBoxFilter(),
    );
  }

  searchBoxFilter() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Transform.translate(
          offset: Offset(0.0, 25.0.h),
          // Adjust as needed for vertical centering
          child: Center(
            // This ensures the search bar is centered
            child: serachBarFilter(),
          ),
        );
      },
    );
  }

  serachBarFilter() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 260.w,
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
                                provider.getBySearchData();
                              },
                              decoration: InputDecoration(
                                  hintText: S().searchNews,
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
        );
      },
    );
  }


  Widget allNewsTag(NewsProvider provider) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, top: 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: ThemeColor.theme_blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: ThemeColor.theme_blue,
              ),
            ),
            label: Text(
              S().allNews,
              style: TextStyle(
                color: !provider.myNews ? Colors.white : Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            selected: !provider.myNews,
            onSelected: (_) => provider.toggleMyNews(false),
          ),
          ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: ThemeColor.theme_blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: ThemeColor.theme_blue,
              ),
            ),
            label: Text(
              "My News",
              style: TextStyle(
                color: provider.myNews ? Colors.white : Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            selected: provider.myNews,
            onSelected: (_) => provider.toggleMyNews(true),
          ),
        ],
      ),
    );
  }


  newsItem(Content content)  {

    return Consumer<NewsProvider>(
      builder: (context, provider, child) {

        return Container(
          width: 375.w,
          //height: 67.h,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Color(0x192C363F)),
              top: BorderSide(color: Color(0x192C363F)),
              right: BorderSide(color: Color(0x192C363F)),
              bottom: BorderSide(width: 1, color: Color(0x192C363F)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${content.topicName!}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${content.date!}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(width: 10,),
                      user!.content!.first.id==content.userId?InkWell(
                        onTap: (){
                          showDeletePopup(content,provider);
                        },
                        child: SvgPicture.asset(Images.delete,),
                      ):SizedBox.shrink()
                    ],
                  ),

                ],
              ),
              Container(
                child: Text(
                  content.description!,
                  style: TextStyle(
                    color: const Color(0x99001E49),
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              BaseWidget().image(image: content.image!),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  if (content.youtubeLink != null &&
                      content.youtubeLink!.isNotEmpty) {
                    _launchURL(content.youtubeLink!);
                  }
                },
                child: Container(
                  child: Text(
                    content.youtubeLink ?? "",
                    style: TextStyle(
                      color: const Color(0x99126CEE),
                      fontSize: 12.0,
                      // Replace `10.sp` if not using `flutter_screenutil`
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    // Ensure the URL has a scheme
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> showDeletePopup(Content content, NewsProvider provider) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S().deleteMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () {
                provider.deletePost(content, context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(S().no,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
