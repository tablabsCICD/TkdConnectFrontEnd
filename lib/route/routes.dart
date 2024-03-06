import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/screen/buy_sell/buy_sell_screen.dart';
import 'package:tkd_connect/screen/buy_sell/create_buy_sell.dart';
import 'package:tkd_connect/screen/edit_post/edit_post_base_screen.dart';
import 'package:tkd_connect/screen/general_post/general_post_list.dart';
import 'package:tkd_connect/screen/general_post/post_comment_list.dart';
import 'package:tkd_connect/screen/group/create_group_screen.dart';
import 'package:tkd_connect/screen/group/edit_group_screen.dart';
import 'package:tkd_connect/screen/group/group_detail_screen.dart';
import 'package:tkd_connect/screen/group/select_user_for_group_screen.dart';
import 'package:tkd_connect/screen/group/group_screen.dart';
import 'package:tkd_connect/screen/intro/intro_screen_one.dart';
import 'package:tkd_connect/screen/intro/intro_screen_three.dart';
import 'package:tkd_connect/screen/intro/intro_screen_two.dart';
import 'package:tkd_connect/screen/jobs/create_job_screen.dart';
import 'package:tkd_connect/screen/jobs/job_list_screen.dart';
import 'package:tkd_connect/screen/my_post/my_post.dart';
import 'package:tkd_connect/screen/search/search_edit_screen.dart';
import 'package:tkd_connect/screen/search/search_result_screen.dart';
import '../entry_screen.dart';
import '../model/request/comment_screen.dart';
import '../model/response/AllCard.dart';
import '../model/response/transport_directory_search.dart';
import '../screen/app_setting/app_setting_screen.dart';
import '../screen/create_post/create_post_base_screen.dart';
import '../screen/dashboard/base_screen.dart';
import '../screen/directory/view_profile.dart';
import '../screen/help_support/HelpSupportScreen.dart';
import '../screen/laguage/select_language.dart';
import '../screen/login/login_screen.dart';
import '../screen/more/edit_profile/edit_profile_base_screen.dart';
import '../screen/my_post/my_post_base_scrren.dart';
import '../screen/my_route/select_city.dart';
import '../screen/notification/notification_list_screen.dart';
import '../screen/otp/otp_screen.dart';
import '../screen/plan/plan_details_screen.dart';
import '../screen/registration/copany_details.dart';
import '../screen/registration/personal_details.dart';
import '../screen/plan/select_plan_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.entryScreen:
        return buildRoute(EntryScreen(), settings: settings);

      case AppRoutes.select_lang:
        return buildRoute(SelectLanguageScreen(), settings: settings);

      case AppRoutes.intro_one:
        return buildRoute(IntroScreenOne(), settings: settings);

      case AppRoutes.intro_two:
        return buildRoute(IntroScreenTwo(), settings: settings);

      case AppRoutes.intro_three:
        return buildRoute(IntroScreenThree(), settings: settings);

      case AppRoutes.login:
        return buildRoute(LoginScreen(), settings: settings);
      case AppRoutes.otp:
        String mobile = settings.arguments as String;
        return buildRoute(
          OTPScreen(
            mobileNumber: mobile,
            isRegistration: false,
          ),
          settings: settings,
        );
        case AppRoutes.otp_registration:
        String mobile = settings.arguments as String;
        return buildRoute(
          OTPScreen(
            mobileNumber: mobile,
            isRegistration: true,
          ),
          settings: settings,
        );
      case AppRoutes.registration_personal_details:
        return buildRoute(PersonalDetailsScreen(), settings: settings);

      case AppRoutes.registration_company_details:
        return buildRoute(CompanyDetailsScreen(), settings: settings);

      case AppRoutes.registration_plan_details:
        return buildRoute(SelectPlanScreen(), settings: settings);

      case AppRoutes.create_post:
       // return buildRoute(CreatePostBase(), settings: settings);
          return _createRoute(CreatePostBase());

      case AppRoutes.viewprofiledirectory:
        TransportSearchData data = settings.arguments as TransportSearchData;
        return buildRoute(ViewProfileDirectory(data: data), settings: settings);

      case AppRoutes.editprofile:
        return buildRoute(EditProfileBaseScreen(), settings: settings);

      case AppRoutes.home:
        return buildRoute(BaseDashboard(), settings: settings);
      case AppRoutes.search:
        return buildRoute(SearchEditScreen(), settings: settings);
      case AppRoutes.searchresult:
        String search = settings.arguments as String;
        return buildRoute(
            SearchResultScreen(
              searchVal: search,
            ),
            settings: settings);
      case AppRoutes.notificationlist:
        return buildRoute(NotificationListScreen(), settings: settings);
      case AppRoutes.helpsupport:
        return buildRoute(HelpSupportScreen(), settings: settings);
      case AppRoutes.appsetting:
        return buildRoute(AppSettingScreen(), settings: settings);

      case AppRoutes.job:
        return buildRoute(JobListScreen(), settings: settings);

      case AppRoutes.group:
        int userId = settings.arguments as int;
        return buildRoute(
            GroupScreen(
              userId: userId,
            ),
            settings: settings);
       // return buildRoute(GeneralPostScreen(), settings: settings);

      case AppRoutes.select_group_member:
        bool isEdit = settings.arguments as bool;
        return _createRoute(SelectUserForGroupScreen(isEdit));

      case AppRoutes.create_group:
        List<UserData> list = settings.arguments as List<UserData> ;
        return _createRoute(CreateGroupScreen(list));

      case AppRoutes.edit_group:
        List<UserData> list = settings.arguments as List<UserData> ;
        return _createRoute(EditGroupScreen(list));

      case AppRoutes.group_info:
        GroupData groupData = settings.arguments as GroupData ;
        return _createRoute(GroupInfo(groupData));

      case AppRoutes.editpost:
        TruckLoad truckLoad = settings.arguments as TruckLoad ;
        return _createRoute(EditPostBase(truckLoad));

      case AppRoutes.mypost:
        return buildRoute(MyPostBase(), settings: settings);

      case AppRoutes.buysell:
        return buildRoute(BuySellScreen(), settings: settings);
      case AppRoutes.createjob:
        return buildRoute(CreateJobScreen(), settings: settings);

      case AppRoutes.createbuysell:
        return buildRoute(CreateBuySell(), settings: settings);

      case AppRoutes.commentscreen:
        TruckLoad commentParmeters=settings.arguments as TruckLoad;

        return buildRoute(PostCommentList(commentParmeters), settings: settings);


      default:

        return buildRoute(EntryScreen(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(

        settings: settings, builder: (BuildContext context) => child);
  }


  static Route _createRoute(Widget root) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => root,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );;
      },
    );
  }





  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Exit App',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 450.0,
                  width: 450.0,
                  //child: Lottie.asset('assets/lottie/error.json'),
                ),
                Text(
                  'Seems the route you\'ve navigated to doesn\'t exist!!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}



