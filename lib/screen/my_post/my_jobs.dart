import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/response/my_post_bid_list.dart';

import '../../provider/my_post/my_post_provider.dart';
import '../../widgets/card/base_widgets.dart';

class MyJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<MyPostProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            controller: provider.scrollController,
            itemCount: provider.listOwnBid.length,
            itemBuilder: (context, i) {
              return Padding(padding: EdgeInsets.only(bottom: 12.h,left: 20.w,right: 20.w),child: iteamMyPost(provider.listOwnBid[i],i),);
            },
          );
        },
      ),
    );
  }

  iteamMyPost(PostBidData listOwnBid, int i) {


  }








}