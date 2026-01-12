import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

// --- app‑specific imports (update paths if they differ) --------------------
import '../../../generated/l10n.dart';
import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../model/response/allNewsResponse.dart';
import '../../model/response/userdata.dart';
import '../../provider/news/news_provider.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../widgets/common_app_bar.dart';
// ---------------------------------------------------------------------------

/// All‑in‑one, scroll‑friendly, ANR‑safe news listing screen.
class AllNewsScreen extends StatefulWidget {
  bool? isBase;
  AllNewsScreen({Key? key, required this.isBase}) : super(key: key);

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  /// Keep a single provider instance (no multiple ChangeNotifier creations).
  final NewsProvider _newsProvider = NewsProvider();

  User? _loggedUser;

  @override
  void initState() {
    super.initState();

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1️⃣  Get current user.
    _loggedUser = await LocalSharePreferences.localSharePreferences.getLoginData();
    // 2️⃣  Load news **after** first frame so build() is never blocked.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newsProvider.loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _newsProvider,
      child: Consumer<NewsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFAB(context, provider),
            body: Column(
              children: [
               // buildNewsHeader(context, provider,true),
                CommonAppBar(
                  title: S.of(context).allNews,
                  isTitle: true,
                  isBack: widget.isBase == false?true:false,  // allow hiding back button
                  isSearchBar: true,
                  isFilter: false,                // news does not have filter
                  searchController: provider.searchController,
                  onBackTap: () => Navigator.pop(context),
                  onSearchChanged: (q) => provider.getBySearchData(),
                ),

                SizedBox(height: 30.h),
                _buildFilterChips(provider),
                // ------------ LIST / EMPTY STATE -------------
                Expanded(
                  child: provider.isLoadDone && provider.allNews.isEmpty
                      ? _buildEmptyState(context)
                      : RefreshIndicator(
                    onRefresh: provider.loadNews,
                    child: ListView.builder(
                      controller: provider.scrollControllerVertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.allNews.length,
                      itemBuilder: (_, index) => _newsItem(
                        context,
                        content: provider.allNews[index],
                        provider: provider,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ────────────────────────── UI COMPONENTS ──────────────────────────

  /// Add‑news button.
  Widget _buildFAB(BuildContext context, NewsProvider provider) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.addNews);
        provider.loadNews(); // 🔄 refresh after returning
      },
      child: Container(
        width: 155.w,
        height: 38.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: ThemeColor.theme_blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).addNews,
              style: TextStyle(
                color: ThemeColor.progress_color,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(Images.add, width: 16.w, height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Top red header with search box.
  Widget buildNewsHeader(BuildContext context, NewsProvider provider, bool isBase) {
    return Stack(
      children: [
        // 🔴 Background AppBar
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.h,
          decoration: const ShapeDecoration(
            color: Color(0xFFC3262C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),

              // Back + Title Row
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    isBase == false
                        ? InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    )
                        : const SizedBox.shrink(),

                    SizedBox(width: 16.w),

                    Text(
                      S.of(context).allNews,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔍 Floating Search Box
        Positioned(
          bottom: 0,
          left: 20.w,
          right: 20.w,
          child: Transform.translate(
            offset: Offset(0, 25.h),
            child: Center(
              child: Container(
                width: 320.w,
                height: 52.h,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: .5, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    SvgPicture.asset(
                      Images.search_normal,
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 8.w),

                    Expanded(
                      child: TextField(
                        controller: provider.searchController,
                        onChanged: (_) => provider.getBySearchData(),
                        decoration: InputDecoration(
                          hintText: S.of(context).searchNews,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: const Color(0x662C363F),
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  /// All / My chips.
  Widget _buildFilterChips(NewsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChoiceChip(
          backgroundColor: Colors.transparent,
          selectedColor: ThemeColor.theme_blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: ThemeColor.theme_blue),
          ),
          label: Text(
            S().allNews,
            style: TextStyle(
              color: !provider.myNews ? Colors.white : Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
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
            side: BorderSide(color: ThemeColor.theme_blue),
          ),
          label: Text(
            S.of(context).myNews,
            style: TextStyle(
              color: provider.myNews ? Colors.white : Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: provider.myNews,
          onSelected: (_) => provider.toggleMyNews(true),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          S.of(context).noRecordFound,
          style: TextStyle(
            color: ThemeColor.theme_blue,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
    );
  }

  /// Single news card.
  Widget _newsItem(BuildContext context, {required Content content, required NewsProvider provider}) {
    final bool isOwner = _loggedUser?.content?.first.id == content.userId;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  content.topicName ?? '-',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                content.date as String,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10.w),
              if (isOwner)
                InkWell(
                  onTap: () => _showDeletePopup(content, provider),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red.shade50,
                    child: SvgPicture.asset(Images.delete, width: 20.w, height: 20.h),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // ── Description ─────────────────────────────────────────────
          Text(
            content.description ?? '',
            style: TextStyle(
              color: const Color(0x99001E49),
              fontSize: 10.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          SizedBox(height: 10.h),

          // ── Image (cached) ──────────────────────────────────────────
          if ((content.image ?? '').isNotEmpty)
            CachedNetworkImage(
              imageUrl: content.image!,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          SizedBox(height: 10.h),

          // ── YouTube link ───────────────────────────────────────────
          if ((content.youtubeLink ?? '').isNotEmpty)
            GestureDetector(
              onTap: () => _launchURL(content.youtubeLink!),
              child: Text(
                content.youtubeLink!,
                style: TextStyle(
                  color: const Color(0x99126CEE),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ────────────────────────── ACTIONS ───────────────────────────────
  Future<void> _launchURL(String url) async {
    final normalised = url.startsWith(RegExp(r'https?://')) ? url : 'https://$url';
    final uri = Uri.parse(normalised);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $normalised')),
      );
    }
  }

  Future<void> _showDeletePopup(Content content, NewsProvider provider) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.of(ctx).delete,
          style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.theme_blue),
        ),
        content: Text(
          S.of(ctx).deleteMsg,
          style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.theme_blue),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.deletePost(content, ctx);
              Navigator.pop(ctx);
            },
            child: Text(
              S.of(ctx).delete,
              style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.of(ctx).no,
              style: TextStyle(fontFamily: AppConstant.FONTFAMILY, color: ThemeColor.green),
            ),
          ),
        ],
      ),
    );
  }
}
