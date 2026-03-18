import 'package:flutter/material.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import 'show_bidds.dart'; // if you want to show bids
import 'place_bid_deeplink.dart'; // if you want to place bid

class QuoteDeepLink extends StatefulWidget {
  final String id;
  final String type;

  const QuoteDeepLink({
    super.key,
    required this.type,
    required this.id,
  });

  @override
  State<QuoteDeepLink> createState() => _QuoteDeepLinkState();
}

class _QuoteDeepLinkState extends State<QuoteDeepLink> {
  @override
  void initState() {
    super.initState();
    callApiQuote(); // ✅ Call quote API
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> callApiQuote() async {
    try {
      User user = await LocalSharePreferences().getLoginData();

      final url = "${ApiConstant.BASE_URL}quote/${widget.id}";
      debugPrint("Quote DeepLink API URL => $url");

      ApiResponse apiResponse =
      await ApiHelper().apiWithoutDecodeGet(url);

      debugPrint("Quote DeepLink Status => ${apiResponse.status}");

     /* if (apiResponse.status == 200 && apiResponse.response != null) {
        QuoteDeep quoteData =
        QuoteDeep.fromJson(apiResponse.response);

        if (quoteData.content == null ||
            quoteData.content!.isEmpty) {
          if (!mounted) return;
          ToastMessage.show(context, "No quote data found");
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (route) => false,
          );
          return;
        }

        final quote = quoteData.content!.first;

        final userMobile = user.content?.first.mobileNumber;
        final quoteMobile = quote.contactNumber; // adjust field name

        if (!mounted) return;

        if (quoteMobile == userMobile) {
          // ✅ Owner View (Quote created by user)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ShowAllBids(id: widget.id),
            ),
          );
        } else {
          // ✅ Other User View (Bid / Respond to Quote)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDeepBidScreen(truckLoad: quote),
            ),
          );
        }
      } else {
        if (!mounted) return;
        ToastMessage.show(context, "Error finding the quote");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
              (route) => false,
        );
      }*/
    } catch (e) {
      debugPrint("Quote DeepLink Error => $e");

      if (!mounted) return;
      ToastMessage.show(context, "Quote is not available");
      Navigator.pop(context);
    }
  }
}
