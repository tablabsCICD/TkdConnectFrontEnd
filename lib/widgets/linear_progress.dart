import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tkd_connect/utils/colors.dart';

class LinearProgressBar extends StatelessWidget{

  final double fillValue;

  const LinearProgressBar({super.key, required this.fillValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335.w,
      height: 6.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 335.w,
              height: 6.h,
              decoration: ShapeDecoration(
                color: const Color(0x4CB7B7B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: fillValue,
              height: 6.h,
              decoration: ShapeDecoration(
                color: ThemeColor.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}