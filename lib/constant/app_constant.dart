import 'package:google_fonts/google_fonts.dart';
import '../model/request/register_company.dart';

class AppConstant{

  static const String APP_VERSION = "3.0.24"; // 101
  static const String GOOGLE_KEY ="AIzaSyDbIESWMKX_4TqGEiFUhbu8-PUpLnVBPrc";
  static const String LOGIN_KEY="login";
  static const String CURRENT_GROUP="group";
  static const String GROUP_MEMBER="member";

  static const String LOGIN_BOOl="loginbool";

  static const String RESENT_SEARCH="search";
  static String PHONE_PAY_TRANSCATION_ID="";
 
  static RegisterCompany registerCompany=RegisterCompany();
  static String? FONTFAMILY=GoogleFonts.poppins().fontFamily;
  static int USERTYPE = 0;

  static const int USER_AGENT = 0;
  static const int USER_TRANSPORTER = 1;
  static const int USER_MANUFACTURER = 2;
  static const int USER_DRIVER = 6;

  static const String BUSINESS_TYPE_AGENT =
      "Agent/Broker/Packers and Movers";
  static const String BUSINESS_TYPE_TRANSPORTER = "Transporter";
  static const String BUSINESS_TYPE_MANUFACTURER =
      "Manufacturer/Distributor/Trade";
  static const String BUSINESS_TYPE_DRIVER = "Truck Driver";
  String TERMS_AND_CONDITION = 'https://tkd-images.s3.ap-south-1.amazonaws.com/1713253757588-1711368168541-termsadnCondition_(1).pdf';
  String PRIVACY_POLICY='https://tkd-images.s3.ap-south-1.amazonaws.com/1753176642391-tkd_privacy_policy.txt';
}