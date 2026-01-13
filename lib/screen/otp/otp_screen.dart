import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tkd_connect/provider/otp_provider/otp_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final bool isRegistration;

  const OTPScreen({
    super.key,
    required this.mobileNumber,
    required this.isRegistration,
  });

  @override
  State<StatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with CodeAutoFill, SingleTickerProviderStateMixin {

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final FocusNode _otpFocusNode = FocusNode();
  final TextEditingController _otpController = TextEditingController(); // ✅ FIX

  String otpCode = '';
  bool isOtpInvalid = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_shakeController);

    listenForCode(); // ✅ START SMS LISTENER
  }

  @override
  void dispose() {
    _otpController.dispose(); // ✅ REQUIRED
    _shakeController.dispose();
    _otpFocusNode.dispose();
    cancel();
    super.dispose();
  }

  // ✅ UPDATE BOTH STRING + CONTROLLER
  void updateOtp(String code) {
    otpCode = code;
    _otpController.text = code;
    isButtonEnabled = otpCode.length == 6;
    setState(() {});
  }

  /// ✅ SMS AUTO-FILL CALLBACK
  @override
  void codeUpdated() {
    final newOtp = code ?? "";

    if (newOtp.length == 6) {
      updateOtp(newOtp);     // ✅ SHOWS IN UI
      verifyOtp(context, newOtp); // ✅ AUTO VERIFY
    }
  }

  Future<void> verifyOtp(BuildContext context, String otpCode) async {
    if (otpCode.length != 6) {
      ToastMessage.show(context, "Please enter a valid 6-digit OTP");
      return;
    }

    String deviceId = '';
    try {
      deviceId = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (_) {}

    final url = ApiConstant.OTP_VERIFICATION(
      widget.mobileNumber,
      otpCode,
      deviceId,
    );

    final req = await ApiHelper().apiPost(url);

    if (req.status == 200) {
      try {
        User user = User.fromJson(req.response);
        if (user.content!.isNotEmpty) {
          LocalSharePreferences prefs = LocalSharePreferences();
          await prefs.setBool(AppConstant.LOGIN_BOOl, true);
          await prefs.setString(
              AppConstant.LOGIN_KEY, jsonEncode(req.response));

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (route) => false,
          );
        } else {
          ToastMessage.show(context, "Please try again");
        }
      } catch (_) {
        ToastMessage.show(context, "Error verifying OTP");
      }
    } else {
      isOtpInvalid = true;
      _shakeController.forward(from: 0);
      ToastMessage.show(context, "Invalid OTP, please try again");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpProvider(
        "Ideal",
        widget.mobileNumber,
        widget.isRegistration,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<OtpProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  SizedBox(height: 128.h),
                  progress(),
                  SizedBox(height: 12.h),
                  mobileNumber(),
                  changeNumber(),
                  SizedBox(height: 52.h),
                  textEnterOTP(),
                  SizedBox(height: 8.h),
                  otpInputField(), // ✅ FIXED
                  SizedBox(height: 12.h),
                  attemptText(),
                  SizedBox(height: 26.h),
                  button(context),
                  SizedBox(height: 32.h),
                  resendOTP(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// ✅ FIXED PIN FIELD (AUTO + MANUAL)
  Widget otpInputField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: PinCodeTextField(
              controller: _otpController, // ✅ MOST IMPORTANT FIX
              focusNode: _otpFocusNode,
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              enableActiveFill: true,

              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 45.h,
                fieldWidth: 45.w,
                activeColor:
                isOtpInvalid ? Colors.red : Colors.green,
                inactiveColor: Colors.grey,
                selectedColor: Colors.black,
                activeFillColor: const Color(0xFFF7F7F7),
                selectedFillColor: const Color(0xFFF7F7F7),
                inactiveFillColor: const Color(0xFFF7F7F7),
              ),

              onChanged: (code) {
                isOtpInvalid = false;
                updateOtp(code); // ✅ MANUAL ENTRY ALSO WORKS
              },

              onCompleted: (code) {
                verifyOtp(context, code);
              },
            ),
          );
        },
      ),
    );
  }

  Widget progress() => Consumer<OtpProvider>(
    builder: (context, provider, child) {
      return SimpleCircularProgressBar(
        progressStrokeWidth: 4,
        size: 40.sp,
        backStrokeWidth: 2,
        maxValue: 150,
        animationDuration: 60,
        progressColors: [ThemeColor.progress_color],
        backColor: ThemeColor.border_grey,
        mergeMode: true,
        onGetText: (double value) {
          return Text( provider.timeRemaining, textAlign: TextAlign.center, style: TextStyle( color: ThemeColor.theme_blue, fontSize: 10.sp, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w400, ), );
        },
      );
    },
  );

  Widget button(BuildContext context) => Consumer<OtpProvider>(
    builder: (context, provider, child) {
      return Button(
        isEnbale: isButtonEnabled,
        title: S.current.Submit,
        width: MediaQuery.of(context).size.width, height: 42.h,  textStyle: TextStyle( color: Colors.white, fontSize: 14.sp, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w600, ),
        onClick: () => verifyOtp(context, otpCode),
      );
    },
  );

  Widget mobileNumber() => Text("OTP sent to +91 ${widget.mobileNumber}");

  Widget changeNumber() => InkWell(
    onTap: () => Navigator.pop(context),
    child: Text("Change number"),
  );

  Widget textEnterOTP() => Text("Enter OTP");

  Widget attemptText() => Text("Attempts 00/03");

  Widget resendOTP() => Consumer<OtpProvider>(
    builder: (context, provider, child) {
      return InkWell(
        onTap: () => provider.onClickResend(context),
        child: Text(
          "Resend OTP",
          style: TextStyle(
            color: provider.resendButtonEnabled
                ? ThemeColor.red
                : Colors.grey,
          ),
        ),
      );
    },
  );
}
