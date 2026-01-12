import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../provider/buy_sell_provider/buy_sell_proovider.dart';
import '../../utils/colors.dart';
import '../../constant/images.dart';
import '../../model/response/AllCard.dart';
import '../../widgets/card/base_widgets.dart';
import '../../generated/l10n.dart';
import '../../route/app_routes.dart';
import '../../widgets/common_app_bar.dart';

class BuySellScreen extends StatefulWidget {
  const BuySellScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CarouselSliderController _carouselController =
  CarouselSliderController();

  @override
  void initState() {
    super.initState();

    // Search listener
    _searchController.addListener(() {
      Provider.of<BuySellProvider>(context, listen: false)
          .updateSearch(_searchController.text.trim());
    });
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuySellProvider(context),
      child: Consumer<BuySellProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: ThemeColor.baground,
            body: Column(
              children: [
                CommonAppBar(
                  title: S().buySell,
                  isTitle: true,
                  isBack: true,
                  isSearchBar: true,
                  isFilter: true,
                  searchController: _searchController,
                  onBackTap: () => Navigator.pop(context),
                  onSearchChanged: (q) => provider.updateSearch(q),
                  onFilterTap: () {
                    provider.initFilterControllers();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => _filterSheet(provider),
                    );
                  },
                ),

                SizedBox(height: 30),
                _tabBuySell(provider),

                // MAIN LIST
                Expanded(child: _listContent(provider)),
              ],
            ),

            // Create post button
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _createPostButton(context),
          );
        },
      ),
    );
  }

  // ================================================================
  // TOP BAR
  // ================================================================

  // ================================================================
  // TAB BUY/SELL
  // ================================================================
  Widget _tabBuySell(BuySellProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(child: _tabChip(provider, false, S().sell)),
          SizedBox(width: 10),
          Expanded(child: _tabChip(provider, true, S().buy)),
        ],
      ),
    );
  }

  Widget _tabChip(BuySellProvider provider, bool isBuy, String label) {
    bool selected = provider.isBuy == isBuy;

    return ChoiceChip(
      backgroundColor: Colors.transparent,
      selectedColor: ThemeColor.theme_blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: ThemeColor.theme_blue)),
      label: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600)),
      selected: selected,
      onSelected: (_) => provider.switchTab(isBuy),
    );
  }

  // ================================================================
  // MAIN LIST VIEW WITH SWIPE REFRESH
  // ================================================================
  Widget _listContent(BuySellProvider provider) {
    if (provider.buySellList.isEmpty && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.buySellList.isEmpty) {
      return _emptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await provider.refresh(); // FULL RESET
      },
      child: ListView.builder(
        controller: provider.scrollController,
        padding: EdgeInsets.only(bottom: 80),
        itemCount:
        provider.buySellList.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == provider.buySellList.length) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final truck = provider.buySellList[index];

          return Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, bottom: 10.h),
            child: _itemBuy(provider, truck, index), // YOUR UI EXACT
          );
        },
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================
  Widget _emptyState() {
    return Center(
      child: Text(S().noRecordFound,
          style: TextStyle(
              color: ThemeColor.theme_blue,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500)),
    );
  }

  // ================================================================
  // CARD UI (UNCHANGED)
  // ================================================================
  Widget _itemBuy(BuySellProvider provider, TruckLoad truckLoad, int index) {
    // NOTE: This is the SAME UI you provided — not modified
    final List<String> imageUrls = [];
    if (truckLoad.images != null && truckLoad.images!.isNotEmpty) {
      for (var img in truckLoad.images!) {
        if (img != null && img.trim().isNotEmpty) imageUrls.add(img.trim());
      }
    }

    return Container(
      width: 335.w,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        shadows: [
          BoxShadow(
              color: const Color(0x114A5568),
              blurRadius: 8.r,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------- your original card UI below unchanged ----------

            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100.w,
                height: 18.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: ShapeDecoration(
                    color: const Color(0xFF2C8FEA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r))),
                child: Center(
                    child: Text(truckLoad.mainTag ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600))),
              ),
            ),
            SizedBox(height: 8.h),

            BaseWidget().profileWithUser(
                "", truckLoad.nameOfPerson!, truckLoad.companyName!,
                verify: truckLoad.isverified!,
                transporterOrAgent: truckLoad.transporterOrAgent!,
                ratings: truckLoad.ratings ?? 0.0,isJob: false,email: ''),

            SizedBox(height: 12.h),

            BaseWidget().heading(
                truckLoad.topicName!,
                truckLoad.postingTime!.split(" ")[0],
                truckLoad.content!),

            SizedBox(height: 8.h),

            if (imageUrls.isNotEmpty)
              Stack(
                children: [
                  CarouselSlider(
                    items: imageUrls.map((url) {
                      return GestureDetector(
                        onTap: () => _showImageDialog(
                            context, imageUrls, imageUrls.indexOf(url)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (c, e, s) =>
                              const Icon(Icons.broken_image, size: 60)),
                        ),
                      );
                    }).toList(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                        height: 180.h,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 1.0,
                        enlargeCenterPage: false),
                  ),
                  Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 22),
                          onPressed: () =>
                              _carouselController.previousPage())),
                  Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 22),
                          onPressed: () => _carouselController.nextPage())),
                ],
              ),

            SizedBox(height: 10.h),

            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                buyListItem("Vehicle Model ", true),
                buyListItem("Vehicle Brand", true),
                buyListItem("Price", true),
                buyListItem("Location", true),
                buyListItem("Vehicle Number", true),
              ]),
              SizedBox(width: 10.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                buyListItem(
                    truckLoad.modelName!.substring(
                        0,
                        truckLoad.modelName!.length > 30
                            ? 30
                            : truckLoad.modelName!.length),
                    false),
                buyListItem(truckLoad.makerName ?? "-", false),
                buyListItem(truckLoad.estPrice ?? "-", false),
                buyListItem(truckLoad.source ?? "-", false),
                buyListItem(truckLoad.vehicleRegistrationNumber ?? "-", false),
              ]),
            ]),

            SizedBox(height: 5.h),

            BaseWidget().buyDeleteButton((val) {
              if (val == 10) {
                _showMyDialog(provider, truckLoad.id!, index);
              }
            }, provider.user!.content!.first.id == truckLoad.userId),

            SizedBox(height: 5.h),

            BaseWidget().buySellCallButton((val) {
              // phone or menu
            }, provider.user!.content!.first.id != truckLoad.userId),

          ]),
    );
  }

  Widget buyListItem(String title, bool isTitle) {
    return Row(children: [
      Text(title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: isTitle ? FontWeight.w600 : FontWeight.w400)),
    ]);
  }

  // ================================================================
  // SHOW IMAGE FULL SCREEN
  // ================================================================
  void _showImageDialog(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(8.r),
          backgroundColor: Colors.black,
          child: Stack(children: [
            PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrls[index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2);
              },
              pageController: PageController(initialPage: initialIndex),
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context))),
          ]),
        );
      },
    );
  }

  // ================================================================
  // CONFIRM DELETE
  // ================================================================
  Future<void> _showMyDialog(
      BuySellProvider provider, int id, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S().complete,
              style: TextStyle(
                  fontFamily: 'Poppins', color: ThemeColor.theme_blue)),
          content: Text(S().deleteMsg,
              style: TextStyle(
                  fontFamily: 'Poppins', color: ThemeColor.theme_blue)),
          actions: <Widget>[
            TextButton(
              child: Text(S().complete,
                  style:
                  TextStyle(fontFamily: 'Poppins', color: ThemeColor.red)),
              onPressed: () {
                provider.deletePost(context, id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S().no,
                  style:
                  TextStyle(fontFamily: 'Poppins', color: ThemeColor.green)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // CREATE POST BUTTON
  // ================================================================
  Widget _createPostButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.createbuysell),
      child: Container(
        width: 155.w,
        height: 38.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: ThemeColor.theme_blue,
            borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Post',
                style: TextStyle(
                    color: ThemeColor.progress_color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600)),
            SizedBox(width: 6.w),
            SvgPicture.asset(Images.add, width: 16.w, height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _filterSheet(BuySellProvider provider) {
    RangeValues priceRange = RangeValues(
      (provider.minPrice ?? 0).toDouble(),
      (provider.maxPrice ?? 5000000).toDouble(),
    );

    List<String> years = List.generate(25, (i) => (2000 + i).toString());
    List<String> suggestions = [
      "Mumbai",
      "Delhi",
      "Chennai",
      "Bangalore",
      "Pune",
      "Hyderabad",
      "Kolkata"
    ];
    List<String> filteredSuggestions = [];

    return StatefulBuilder(
        builder: (context, setState) =>
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                  left: 20,
                  right: 20,
                  top: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12)),
                    )),
                    SizedBox(height: 20),

                    _outlined("Company Name", provider.companyCtrl),
                    _outlined("Person Name", provider.personCtrl),

                    _outlined("Location", provider.locationCtrl, onChanged: (v) {
                      setState(() {
                        filteredSuggestions = suggestions
                            .where((x) =>
                            x.toLowerCase().contains(v.toLowerCase()))
                            .toList();
                      });
                    }),

                    if (filteredSuggestions.isNotEmpty)
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListView(
                          children: filteredSuggestions
                              .map((e) =>
                              ListTile(
                                title: Text(e),
                                onTap: () {
                                  provider.locationCtrl.text = e;
                                  setState(() => filteredSuggestions = []);
                                },
                              ))
                              .toList(),
                        ),
                      ),

                    _outlined("Model", provider.modelCtrl),
                    _outlined("Vehicle Size", provider.vehicleSizeCtrl),

                    SizedBox(height: 12),
                    DropdownButtonFormField(
                      value: provider.mfgYear,
                      decoration: InputDecoration(
                        labelText: "Manufacture Year",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: years.map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => provider.mfgYear = v,
                    ),

                    SizedBox(height: 20),
                    Text("Price Range (₹)",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 5000000,
                      divisions: 100,
                      labels: RangeLabels(
                        "₹${priceRange.start.toInt()}",
                        "₹${priceRange.end.toInt()}",
                      ),
                      onChanged: (val) {
                        setState(() => priceRange = val);
                      },
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹${priceRange.start.toInt()}"),
                        Text("₹${priceRange.end.toInt()}"),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black),
                            onPressed: () {
                              provider.clearFilters();
                              Navigator.pop(context);
                            },
                            child: Text("Clear Filters"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              provider.applyFilters(
                                company: provider.companyCtrl.text,
                                person: provider.personCtrl.text,
                                loc: provider.locationCtrl.text,
                                mod: provider.modelCtrl.text,
                                year: provider.yearCtrl.text,
                                size: provider.vehicleSizeCtrl.text.trim(),
                                min: priceRange.start.toInt()==0?null:priceRange.start.toInt(),
                                max: priceRange.end.toInt()==500000?null:priceRange.end.toInt(),
                              );
                              Navigator.pop(context);
                            },
                            child: Text("Apply Filters"),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
    );
  }

  // INPUT FIELD
  Widget _outlined(String label, TextEditingController controller,
      {Function(String)? onChanged}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
