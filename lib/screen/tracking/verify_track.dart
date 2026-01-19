import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/response/driver_verification_response.dart';
import 'package:tkd_connect/screen/tracking/vehicle_tracking.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'dart:convert';
import 'package:tkd_connect/utils/toast.dart';
import '../../provider/location/location_provider.dart';

class VerifyTrack extends StatefulWidget {
  const VerifyTrack({super.key});

  @override
  State<VerifyTrack> createState() => _VerifyTrackState();
}

class _VerifyTrackState extends State<VerifyTrack> {
  final TextEditingController _postIdController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;

  // 0 = none, 1 = Post Owner, 2 = Quote Owner
  int _selectedType = 1;

  Future<void> verifyOtp() async {
    final postId = _postIdController.text.trim();
    final otp = _otpController.text.trim();

    if (postId.isEmpty || otp.isEmpty) {
      ToastMessage.show(context, 'Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    String url = ApiConstant.OTP_TRACKING_VERIFICATION(
        _selectedType == 1 ? true : false, otp, postId);
    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      print(response.body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ToastMessage.show(context, 'OTP verified successfully!');

        DriverVerificationResponse driverVerificationResponse =
        DriverVerificationResponse.fromJson(data);

        if ((driverVerificationResponse.data?.vehicleNumber?.isNotEmpty ?? false) &&
            (driverVerificationResponse.data?.driverContact?.isNotEmpty ?? false)) {

          // 🔔 STEP 1: Request Notification Permission (Android 13+)
          if (await Permission.notification.isDenied) {
            await Permission.notification.request();
          }

          final provider = context.read<TrackingProvider>();
          provider.setSelectedVehicle(postId);
          await provider.startTrackingVehicles([postId],
            vehicleNumber:
            driverVerificationResponse.data?.vehicleNumber ?? "",
            driverContact:
            driverVerificationResponse.data?.driverContact ?? "",
            postOwnerNumber: driverVerificationResponse.data?.postOwnerNumber ?? "",
            quoteOwnerNumber: driverVerificationResponse.data?.quoteOwnerNumber ?? "");

        }
      } else {
        ToastMessage.show(context, data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      ToastMessage.show(context, 'Error: $e');
    }

    _postIdController.clear();
    _otpController.clear();
    setState(() => _isLoading = false);
  }


  Timer? locationTimer;

  /* void startForegroundTracking(String postId, String vehicle, String driver) {
    locationTimer?.cancel(); // ✅ Prevent duplicate timers

    locationTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      sendLocationToServer(postId, vehicle, driver);
    });
  }*/

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: ThemeColor.red,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Verify Driver OTP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _postIdController,
                  decoration: InputDecoration(
                    labelText: 'Post ID',
                    prefixIcon: const Icon(Icons.confirmation_number_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                // 🔘 Radio Buttons Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Verification Type",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    RadioListTile<int>(
                      title: const Text("Verify for Post Owner"),
                      value: 1,
                      groupValue: _selectedType,
                      activeColor: ThemeColor.theme_blue,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text("Verify for Quote Owner"),
                      value: 2,
                      groupValue: _selectedType,
                      activeColor: ThemeColor.theme_blue,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.theme_blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
