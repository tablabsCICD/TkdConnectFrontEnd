import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../model/response/AllCard.dart';
import '../../provider/search_provider/search_provider.dart';
import '../../widgets/card/dashboard_cards.dart';

class SearchPostScreen extends StatefulWidget{
   SearchProvider searchProvider;
   final String serach;

   SearchPostScreen({super.key, required this.searchProvider, required this.serach});

  @override
  State<StatefulWidget> createState() {
    return _SearchPostState();
  }

}
class _SearchPostState extends State<SearchPostScreen>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.searchProvider.pagenation(context, widget.serach);
    widget.searchProvider.callPostApiSearch(context, 0,widget.serach);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => widget.searchProvider,
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context){
    return Consumer<SearchProvider>(
  builder: (context, provider, child) {
  return Container(
      child:

      provider.truckLoadTypeList.length==0 && !provider.isLoading?Center(
        child: Text(
          "No Data found",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ) :listCard(),
    );
  },
);
  }
  listCard() {

    return  Expanded(
      child: ListView.builder(
          controller: widget.searchProvider.scrollController,
          itemCount: widget.searchProvider.truckLoadTypeList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(bottom: 20.h,left: 20.w,right: 20.w),
              child: setCardToList(index, widget.searchProvider.truckLoadTypeList[index]),
            );
          }),
    );

  }
  setCardToList(int index,TruckLoad truckLoad){
    if(truckLoad.type=="Full Load" || truckLoad.type=="Part Load"){
      return AllCards().cardLoad(index, context, truckLoad);
    }else if(truckLoad.type=="General Post"){
      return AllCards().generalPost(truckLoad,context);
    }else{
      return AllCards().generalPost(truckLoad,context);
    }
  }
}