import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/datepicker.dart';
import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../provider/dashboard/post_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/editText.dart';
import '../my_route/select_one_city.dart';

class PostVehicleScreen extends StatefulWidget {
  const PostVehicleScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PostVehicleScreen();
  }
}

class _PostVehicleScreen extends State<PostVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PostLoadProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            children: [
              SizedBox(
                height: 20.h,
              ),
              _label("${S().vehicle} ${S().loads}"),
              dropDownWithInnerMic(
                  context: context,
                  provider: provider,
                  hint: provider.selectedRequriment,
                  field: VoiceField.loadType,
                  onTap: () async {
                    ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                    int a = await itemBottomSheet.showIteam(context,
                        provider.reqirementVehicale, "Select Load Type");
                    provider.selectedRequrimentVehicaleType(a);
                  },
                  isMicVisible: false),

              /* DropDown(
                onClick: () async {
                  ItemBottomSheet itemBottomSheet = ItemBottomSheet();
                  int a = await itemBottomSheet.showIteam(context, provider.reqirementVehicale, "Select Load Type");
                  provider.selectedRequrimentVehicaleType(a);
                },
                hint: provider.selectedRequriment,
              ),*/
              _gap(),
              _label(S().fromCity),
              _dropDownWithMic(
                context,
                provider,
                provider.sourceCity,
                VoiceField.fromCity,
                () async {
                  RouteRequest r = await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => const FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SelectOneCityScreen(),
                    ),
                  );
                  provider.selectedSourceCity(r.startLocation);
                },
              ),
              _gap(),
              _label(S().toCity),
              _dropDownWithMic(
                context,
                provider,
                provider.destinationCity,
                VoiceField.toCity,
                () async {
                  RouteRequest r = await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => const FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SelectOneCityScreen(),
                    ),
                  );
                  provider.selectedDestinationCity(r.startLocation);
                },
              ),
              _gap(),
              _label(S().cargoType),
              dropDownWithInnerMic(
                  context: context,
                  provider: provider,
                  hint: provider.selectedCargo,
                  field: VoiceField.cargoType,
                  onTap: () async {
                    final i = await ItemBottomSheet().showIteam(
                      context,
                      provider.cargoList,
                      "Select Cargo Type",
                    );
                    provider.selectedCargoType(i);
                  },
                  isMicVisible: true),
              _gap(),
              _label(S().vehicleSize),
              _textFieldWithMic(
                provider,
                provider.vehicleSizeController,
                provider.vehicaleSize,
                "eg. 13 ft",
                VoiceField.vehicleSize,
              ),
              _gap(),
              _label(S().loadWeight),
              _textFieldWithMic(
                provider,
                provider.loadWeightController,
                provider.loadWieght,
                "In Tons",
                VoiceField.loadWeight,
              ),
              _gap(),
              _label(S().mobileNumber),
              _textFieldWithMic(
                provider,
                provider.mobileNumberController,
                true,
                "eg. 88XXXXXX90",
                VoiceField.mobile,
                readOnly: true,
              ),
              _gap(),
              _label(S().email_id),
              _textFieldWithMic(
                provider,
                provider.emailIdController,
                true,
                "eg. abc@gmail.com",
                VoiceField.email,
                readOnly: true,
              ),
              _gap(),
              _label(S().specialInstruction),
              dropDownWithInnerMic(
                  context: context,
                  provider: provider,
                  hint: provider.selectedSI,
                  field: VoiceField.instruction,
                  onTap: () async {
                    final i = await ItemBottomSheet().showIteam(
                      context,
                      provider.specialInstructionList,
                      "Select Special Instruction",
                    );
                    provider.selectedSpecialInstruction(i);
                  },
                  isMicVisible: true),
              /* _textFieldWithMic(
                provider,
                provider.specialInstructionController,
                true,
                "Not available",
                VoiceField.instruction,
              ),*/
              if (provider.aiError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    provider.aiError,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              _gap(),
              _label(S().expiryDate),
              _datePicker(
                  context, provider.expiryDateController, provider.setDate),
              _gap(),
              _label(S().paymentType),
              dropDownWithInnerMic(
                  context: context,
                  provider: provider,
                  hint: provider.selectedPayment,
                  field: VoiceField.paymentType,
                  onTap: () async {
                    final i = await ItemBottomSheet().showIteam(
                      context,
                      provider.paymentList,
                      "Select Payment Type",
                    );
                    provider.selectedPaymentType(i);
                  },
                  isMicVisible: true),
              _gap(),
              _switchTile("Do Not Disturb", provider.dnd, provider.dndChange),
              _gap(),
              _switchTile(
                  "Hide my identity", provider.hideMyID, provider.hideMyId),
              _gap(),
              _switchTile(
                  "Repeat Post", provider.isRepeat, provider.repeatPostSwitch),
              if (provider.isRepeat) ...[
                _gap(),
                _label("End Date of Repeat Post"),
                _datePicker(
                    context, provider.endDateController, provider.setEndDate),
              ],
              _gap(),
              _label("Show Post to"),
              DropDown(
                onClick: () async {
                  final i = await ItemBottomSheet().showIteam(
                    context,
                    provider.listOptionShow,
                    provider.selectOption,
                  );
                  provider.selecteOptiontoShow(i, context);
                },
                hint: provider.selectedGroup,
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Button(
                  width: MediaQuery.of(context).size.width,
                  height: 49.h,
                  title: S().postLoad,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  onClick: () async {
                    provider.checkVehicaleValidation(context);
                  },
                  isEnbale: true,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  repeatPost(context) {
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 33.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Repeat Post",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: AppConstant.FONTFAMILY,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Color(0x99001E49),
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 40.sp,
                child: Switch.adaptive(
                  // This bool value toggles the switch.
                  value: provider.isRepeat,
                  splashRadius: 10,
                  activeColor: ThemeColor.theme_blue,
                  onChanged: (bool value) {
                    provider.repeatPostSwitch(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  labelText(String label) {
    return SizedBox(
      width: 332.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  editView(String hint, TextEditingController controller,
      PostLoadProvider provider, bool redOnly) {
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        provider.enble();
      },
    );
  }

  editViewError(String hint, TextEditingController controller,
      PostLoadProvider provider, bool valid) {
    return EditTextError(
      validate: valid,
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        provider.enble();
      },
    );
  }

  dnd(context) {
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 33.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Do Not Disturb",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: AppConstant.FONTFAMILY,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Color(0x99001E49),
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 129),
              SizedBox(
                width: 100.w,
                height: 40.sp,
                child: Switch.adaptive(
                  // This bool value toggles the switch.
                  value: provider.dnd,
                  splashRadius: 10,
                  activeColor: ThemeColor.theme_blue,
                  onChanged: (bool value) {
                    provider.dndChange(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  hideMyIden(context) {
    return Consumer<PostLoadProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 33.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Hide my identity",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: AppConstant.FONTFAMILY,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Color(0x99001E49),
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 40.sp,
                child: Switch.adaptive(
                  // This bool value toggles the switch.
                  value: provider.hideMyID,
                  splashRadius: 10,
                  activeColor: ThemeColor.theme_blue,
                  onChanged: (bool value) {
                    provider.hideMyId(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fieldMic(PostLoadProvider provider, VoiceField field) {
    final active = provider.isListening && provider.activeVoiceField == field;

    return AvatarGlow(
      animate: active,
      glowColor: Colors.red,
      endRadius: 28 + provider.micLevel * 3,
      child: GestureDetector(
        onTap: () => provider.toggleMicForField(field),
        child: Icon(
          active ? Icons.stop : Icons.mic,
          color: active ? Colors.red : ThemeColor.theme_blue,
          size: 20,
        ),
      ),
    );
  }

  Widget _textFieldWithMic(
    PostLoadProvider provider,
    TextEditingController controller,
    bool valid,
    String hint,
    VoiceField field, {
    bool readOnly = false,
  }) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        // 📝 TEXT FIELD
        EditTextError(
          validate: valid,
          hint: hint,
          controller: controller,
          readOnly: readOnly,
          onChange: (_) => provider.enble(),
          width: double.infinity,
          height: 48,
        ),

        // 🎤 MIC (ONLY IF NOT READ-ONLY)
        if (!readOnly)
          Positioned(
            right: 12,
            child: _fieldMic(provider, field),
          ),
      ],
    );
  }

  Widget _dropDownWithMic(
    BuildContext context,
    PostLoadProvider provider,
    String hint,
    VoiceField field,
    VoidCallback onTap,
  ) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        DropDown(onClick: onTap, hint: hint),
        Positioned(right: 25, child: _fieldMic(provider, field)),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      );

  Widget _gap() => SizedBox(height: 12.h);

  Widget _datePicker(
    BuildContext context,
    TextEditingController c,
    Function(String) onPick,
  ) =>
      EditText(
        readOnly: true,
        hint: "dd/mm/yyyy",
        controller: c,
        onTap: () async {
          final d = await DateTimePickerDialog().pickDateDialog(context);
          onPick(d);
        },
        width: 300,
        height: 40,
      );

  Widget _switchTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x332C363F)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: ThemeColor.theme_blue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget dropDownWithInnerMic({
    required BuildContext context,
    required PostLoadProvider provider,
    required String hint,
    required VoiceField field,
    required VoidCallback onTap,
    required bool isMicVisible,
  }) {
    final isActive = provider.isListening && provider.activeVoiceField == field;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // ⬇️ ORIGINAL DROPDOWN
        DropDown(
          onClick: onTap,
          hint: hint,
        ),

        // 🎤 MIC INSIDE (LEFT)
        isMicVisible
            ? Positioned(
                right: 30,
                child: AvatarGlow(
                  animate: isActive,
                  glowColor: Colors.red,
                  endRadius: 22 + provider.micLevel * 2,
                  child: GestureDetector(
                    onTap: () => provider.toggleMicForField(field),
                    child: Icon(
                      isActive ? Icons.stop : Icons.mic,
                      size: 20,
                      color: isActive ? Colors.red : ThemeColor.theme_blue,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
