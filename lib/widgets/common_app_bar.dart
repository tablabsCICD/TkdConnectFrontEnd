import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/colors.dart';
import '../constant/images.dart';

class CommonAppBar extends StatelessWidget {
  final String? title;
  final bool isTitle;
  final bool isBack;
  final bool isSearchBar;
  final bool isFilter;

  final VoidCallback? onBackTap;
  final Function(String)? onSearchChanged;
  final VoidCallback? onFilterTap;

  final TextEditingController? searchController;

  const CommonAppBar({
    Key? key,
    this.title,
    required this.isTitle,
    required this.isBack,
    required this.isSearchBar,
    required this.isFilter,
    this.onBackTap,
    this.onSearchChanged,
    this.onFilterTap,
    this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _topBar(),

        if (isSearchBar)
          Positioned(
            bottom: -25,
            left: 0,
            right: 0,
            child: _searchRow(),
          ),
      ],
    );
  }

  // =====================================================================
  // TOP RED BACKGROUND BAR
  // =====================================================================
  Widget _topBar() {
    return Container(
      height: isSearchBar==false && isFilter==false ?85.h:120.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFC3262C),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: isSearchBar==false && isFilter==false ?25:10),
        child: Row(
          children: [
            if (isBack)
              InkWell(
                onTap: onBackTap,
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),

            if (isBack) SizedBox(width: 12),

            if (isTitle)
              Text(
                title ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),


          ],
        ),
      ),
    );
  }

  // =====================================================================
  // SEARCH + FILTER ROW
  // =====================================================================
  Widget _searchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _searchField(),
        if (isFilter) SizedBox(width: 8.w),
        if (isFilter) _filterCard(),
      ],
    );
  }

  // Search Box
  Widget _searchField() {
    return Container(
      width: 260.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0x332C363F)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SvgPicture.asset(Images.search_normal, width: 22, height: 22),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search here",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Icon (white card)
  Widget _filterCard() {
    return InkWell(
      onTap: onFilterTap,
      child: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0x332C363F)),
        ),
        child: Center(
          child: SvgPicture.asset(
            Images.filter,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
