import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/provider/dashboard/rating_provider.dart';
import 'package:tkd_connect/utils/rating_star.dart';
import 'package:tkd_connect/widgets/button.dart';

class RatingDialog extends StatefulWidget {
  TruckLoad? load;
  RatingDialog(this.load, {super.key});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RatingProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<RatingProvider>(
        builder: (context, provider, child)=> Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rating and Review',style: TextStyle(color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w600,),),
                  InkWell(onTap:(){Navigator.pop(context);},child: SvgPicture.asset(Images.close_circle))

                ],
              ),
              const SizedBox(height: 25),
              Text(
                widget.load!.companyName.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(height: 10.h,),
              Text('How would you rate this Company?',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,
                fontSize: 13.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w500,),),
              const SizedBox(height: 20),
              StarRating(
                  rating: provider.rating,
                  onRatingChanged: (rating) {
                    if(rating==0){
                      provider.buttonEnable=false;
                    }else{
                      provider.buttonEnable=true;
                    }
                    provider.changeRating(rating);}
              ),
              const SizedBox(height: 20),
              TextField(
                controller: provider.commentController,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  hintStyle: TextStyle(color: Colors.black38,
                    fontSize: 13.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w500,),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (val){
                  if(val==0){
                    provider.buttonEnable=false;
                  }else{
                    provider.buttonEnable=true;
                  }
                  provider.callSetState();
                },
              ),
            ],
          ),
        )/*AlertDialog(
          title: Text('Rate and Review',style: TextStyle(color: Colors.black,
            fontSize: 18.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,)),
          content:  Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How would you rate this Company?',style: TextStyle(color: Colors.black,
                  fontSize: 13.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w500,),),
                SizedBox(height: 20),
                StarRating(
                  rating: provider.rating,
                  onRatingChanged: (rating) => provider.changeRating(rating)
                ),
                SizedBox(height: 20),
                TextField(
                  controller: provider.commentController,
                  decoration: InputDecoration(
                    hintText: 'Write your review...',
                    hintStyle: TextStyle(color: Colors.black38,
                      fontSize: 13.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                print('Rating: ${provider.rating}');
                provider.postRatingRaviews(context);
                Navigator.of(context).pop();
              },
              child: Text('SUBMIT'),
            ),
          ],
        )*/,
      ),
      bottomNavigationBar: Consumer<RatingProvider>(
        builder: (context, provider, child)=> Padding(padding: const EdgeInsets.fromLTRB(20,10,20,20),child: Button(width: 327.w, height: 49.h, title: S().submit, textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: AppConstant.FONTFAMILY,
          fontWeight: FontWeight.w600,
          height: 0,
        ), onClick: (){
          print('Rating: ${provider.rating}');
          provider.postRatingRaviews(context,widget.load);
          Navigator.of(context).pop();
        },isEnbale: provider.buttonEnable,),),
      ),

    );
  }

}