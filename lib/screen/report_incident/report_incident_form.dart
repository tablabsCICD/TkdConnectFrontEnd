import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../provider/incident/report_incident_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/datepicker.dart';
import '../../widgets/editText.dart';

class ReportIncidentFormScreen extends StatelessWidget {
  final List<String> _incidentTypes = [
    "Theft",
    "Fake RTO Documents",
    "Non-existing Company",
    "Vehicle Missing",
    "Driver Missing",
    "Owner Missing",
    "Others (Specify Below)"
  ];

  final List<String> _cheatedByOptions = [
    "Vehicle Owner / Transport Company / Driver",
    "Agent",
    "Manufacturer",
    "Trader",
    "Others (Specify)"
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ReportIncidentProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {

    final provider = Provider.of<ReportIncidentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Incident",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color(0xFFC3262C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMultiSelectChips("Incident Type", _incidentTypes,
                  provider.incidentTypes, provider.toggleIncidentType),
              SizedBox(height: 16),
              _buildMultiSelectChips("Cheated By", _cheatedByOptions,
                  provider.cheatedBy, provider.toggleCheatedBy),
              SizedBox(height: 16),
              _buildRadioButtons("Was FIR Launched?", ["Yes", "No"],
                  provider.wasFirLaunched, provider.updateFirStatus),
              SizedBox(height: 16),
              labelText("Name"),
              SizedBox(
                height: 4.h,
              ),
              editViewError(
                  "your name", provider.nameController, provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText(S().contact),
              SizedBox(
                height: 4.h,
              ),
              editViewError("Contact number", provider.phoneNumberController,
                  provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("Vehicle Number",isMandatory: true),
              SizedBox(
                height: 4.h,
              ),
              editViewError("vehicle number", provider.vehicleNumberController,
                  provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("Date of Incident",isMandatory: true),
              SizedBox(
                height: 4.h,
              ),
              _buildText(context, "yyyy-mm-dd",
                  provider.dateOfIncidentController, provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("Short Incident Description"),
              SizedBox(
                height: 4.h,
              ),
              editViewError("description", provider.shortDescriptionController,
                  provider, true),
              SizedBox(
                height: 12.h,
              ),
              labelText("Amount Lost / Goods Cheated"),
              SizedBox(
                height: 4.h,
              ),
              editViewError("ex- 1000",
                  provider.amountLostOrGoodsCheatedController, provider, true),
              SizedBox(
                height: 12.h,
              ),
              _buildProofUploader(provider, context),
              SizedBox(height: 30),
              _buildDeclarationAndSubmitButton(context, provider),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Button(
                  width: MediaQuery.of(context).size.width,
                  height: 49.h,
                  title: S().submit,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  onClick: () {
                    provider.checkValidation(context);
                  },
                  isEnbale: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectChips(String title, List<String> options,
      List<String> selectedOptions, Function toggleOption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText(
          title,
          isMandatory: true

        ),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return ChoiceChip(
              label: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  // Change text color based on selection
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
              selected: isSelected,
              selectedColor: ThemeColor.theme_blue,
              // Set the background color for selected chips
              backgroundColor: Colors.grey[200],
              // Background color for unselected chips
              onSelected: (_) => toggleOption(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRadioButtons(String title, List<String> options,
      bool? selectedOption, Function(bool?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black, // Change text color based on selection
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: options.map((option) {
            return Expanded(
              child: ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    color: Colors.black, // Change text color based on selection
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                leading: Radio<bool?>(
                  value: option == "Yes",
                  groupValue: selectedOption,
                  onChanged: onChanged,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildText(context, String hint, TextEditingController controller,
      ReportIncidentProvider provider, bool redOnly) {
    return EditText(
      readOnly: true,
      width: 335.w,
      height: 52.h,
      hint: "dd/mm/yyyy",
      controller: controller,
      onTap: () async {
        String Date = await DateTimePickerDialog().pickBeforeDateDialog(context);
        provider.setDate(Date);
      },
    );
  }

  Widget _buildProofUploader(
      ReportIncidentProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        labelText(
          "Upload Proof (documents, images, receipts)",
          isMandatory: provider.wasFirLaunched==true?true:false
        ),
        provider.images.isNotEmpty
            ? BaseWidget().carouseImageDelete(provider.images, (item) {
                provider.images.remove(item);
                provider.notifyListeners();
              })
            : const SizedBox(),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
            onTap: () {
              provider.uploadImage(context);
            },
            child: SvgPicture.asset(Images.add_image)),
        Text(
          "Upload Images",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF001E49),
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        ...provider.uploadedProofs.map((proof) => ListTile(title: Text(proof))),
      ],
    );
  }

  Widget _buildDeclarationAndSubmitButton(
      BuildContext context, ReportIncidentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Declaration Checkbox
        CheckboxListTile(
          activeColor: Color(0xFFC3262C), // Customize checkbox color
          title: Text(
            "I hereby declare that the above information is true to the best of my knowledge. I understand that submitting false information may result in legal action. I agree that Tkd Connect is not responsible for the accuracy of this content and I take full responsibility for this submission.",
            style: TextStyle(
              color: provider.isAccepted == true ? Colors.green : Colors.black, // Change text color dynamically
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          value: provider.isAccepted ?? false,
          onChanged: (value) {
            provider.updateAcceptedTerm(value ?? false);
          },
        ),

      ],
    );
  }


  labelText(String label, {bool isMandatory = false}) {
    return SizedBox(
      width: 332.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),
              children: isMandatory
                  ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: ThemeColor.secondary_color,
                    fontSize: 12.sp,
                  ),
                ),
              ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  editView(String hint, TextEditingController controller,
      ReportIncidentProvider provider, bool redOnly) {
    return EditText(
      readOnly: redOnly,
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
      ReportIncidentProvider provider, bool valid) {
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
}
