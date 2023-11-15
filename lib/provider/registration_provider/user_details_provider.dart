import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/provider/registration_provider/base_registration_provider.dart';

import '../../constant/app_constant.dart';
import '../../route/app_routes.dart';
import '../../utils/validation.dart';

class UserDetailsProvider extends BaseRegistartionProvider {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController mobileNameController = TextEditingController();
  bool isEnbale = false;

  UserDetailsProvider(super.appState);

  checkValidation() {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailNameController.text.isNotEmpty &&
        mobileNameController.text.isNotEmpty) {
      if (Validation()
              .isValidPhoneNumber(mobileNameController.text.toString()) &&
          Validation()
              .isValidEmail(emailNameController.text.toString())) {
        isEnbale = true;
      } else {
        isEnbale = false;
      }
    } else {
      isEnbale = false;
    }

    notifyListeners();
  }

  saveData(BuildContext context){
    AppConstant.registerCompany.firstName=firstNameController.text.toString();
    AppConstant.registerCompany.lastName=lastNameController.text.toString();
    AppConstant.registerCompany.emailId=emailNameController.text.toString();
    AppConstant.registerCompany.mobileNumber=mobileNameController.text.toString();
    Navigator.pushReplacementNamed(context, AppRoutes.registration_company_details);

  }
}
