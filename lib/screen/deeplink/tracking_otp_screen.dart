import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constant/api_constant.dart';
import '../../generated/l10n.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/driver_verification_response.dart';
import '../../network/api_helper.dart';
import '../../provider/location/location_provider.dart';
import '../../utils/toast.dart';
import '../../widgets/button.dart';

class TrackingOtpScreen extends StatefulWidget {
  final String postId; // from deep link
  bool isPostOwner;
  TrackingOtpScreen({super.key, required this.postId, required this.isPostOwner});

  @override
  State<TrackingOtpScreen> createState() => _TrackingOtpScreenState();
}

class _TrackingOtpScreenState extends State<TrackingOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isError = false;

  int _selectedType = 1; // 1 = post, 2 = quote (change if needed)

  @override
  void initState() {
    super.initState();
  }

   /// 🔹 VERIFY OTP API (YOUR LOGIC – CLEANED)
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ToastMessage.show(context, 'Please enter OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    String url = ApiConstant.OTP_TRACKING_VERIFICATION(
      widget.isPostOwner,
      otp,
      widget.postId,
    );
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ToastMessage.show(context, 'OTP verified successfully ✅');

        final driverVerificationResponse =
            DriverVerificationResponse.fromJson(data);

        final vehicleNumber =
            driverVerificationResponse.data?.vehicleNumber ?? '';
        final driverContact =
            driverVerificationResponse.data?.driverContact ?? '';

        if (vehicleNumber.isNotEmpty && driverContact.isNotEmpty) {
          // 🔔 Notification permission (Android 13+)
          if (await Permission.notification.isDenied) {
            await Permission.notification.request();
          }

          final provider = context.read<TrackingProvider>();
          provider.setSelectedVehicle(widget.postId);

          await provider.startTrackingVehicles(
            [widget.postId],
            vehicleNumber: vehicleNumber,
            driverContact: driverContact,
            postOwnerNumber: driverVerificationResponse.data!.postOwnerNumber??"",
            quoteOwnerNumber: driverVerificationResponse.data!.quoteOwnerNumber??"",
          );

          // 🔥 Move to tracking screen
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _isError = true;
        ToastMessage.show(context, data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      ToastMessage.show(context, 'Error: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'OTP Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFC3262C),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Enter Tracking OTP',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, letterSpacing: 4),
              decoration: InputDecoration(
                hintText: '••••••',
                counterText: '',
                errorText: _isError ? 'Invalid OTP' : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            Button(
              width: MediaQuery.of(context).size.width,
              height: 49.h,
              title: "Verify OTP",
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
              onClick: () {
                if (!_isLoading) {
                  _verifyOtp();
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
