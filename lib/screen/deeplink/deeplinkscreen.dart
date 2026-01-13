import 'package:flutter/material.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/deeplink/place_bid_deeplink.dart';
import 'package:tkd_connect/screen/deeplink/show_bidds.dart';
import 'package:tkd_connect/screen/my_bids/my_bids_base_screen.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../model/response/deep_link_load.dart';

class DeepLink extends StatefulWidget {
  final String id;
  final String type;
  const DeepLink({super.key,  required this.type,required this.id,});

  @override
  State<DeepLink> createState() => _DeepLinkState();
}

class _DeepLinkState extends State<DeepLink> {
  @override
  void initState() {
    super.initState();
    callApiPost(); // ✅ Always after super.initState()
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> callApiPost() async {
    try {
      User user = await LocalSharePreferences().getLoginData();

      final url = "${ApiConstant.BASE_URL}fullTruckLoad/${widget.id}";
      debugPrint("DeepLink API URL => $url");

      ApiResponse apiResponse =
      await ApiHelper().apiWithoutDecodeGet(url);

      debugPrint("DeepLink Status => ${apiResponse.status}");

      if (apiResponse.status == 200 && apiResponse.response != null) {
        TruckDeep truckLoadType =
        TruckDeep.fromJson(apiResponse.response);

        if (truckLoadType.content == null ||
            truckLoadType.content!.isEmpty) {
          if (!mounted) return;
          ToastMessage.show(context, "No load data found");
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (route) => false,
          );
          return;
        }

        Content load = truckLoadType.content!.first;

        final userMobile = user.content?.first.mobileNumber;
        final loadMobile = load.contactNumber;

        if (!mounted) return;

        if (loadMobile == userMobile) {
          // ✅ Owner View
         /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ShowAllBids(id: widget.id),
            ),
          );*/
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MyBidsBaseScreen(),
            ),
          );
        } else {
          // ✅ Other User View
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDeepBidScreen(truckLoad: load),
            ),
          );
        }
      } else {
        if (!mounted) return;
        ToastMessage.show(context, "Error finding the load");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint("DeepLink Error => $e");

      if (!mounted) return;
      ToastMessage.show(context, "Post is not available");
      Navigator.pop(context);
    }
  }
}
