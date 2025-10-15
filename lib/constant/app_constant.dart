import 'package:google_fonts/google_fonts.dart';
import '../model/request/register_company.dart';

class AppConstant{

  static const String APP_VERSION = "3.0.23"; // 91
  static const String GOOGLE_KEY ="AIzaSyDbIESWMKX_4TqGEiFUhbu8-PUpLnVBPrc";
  static const String LOGIN_KEY="login";
  static const String CURRENT_GROUP="group";
  static const String GROUP_MEMBER="member";

  static const String LOGIN_BOOl="loginbool";

  static const String RESENT_SEARCH="search";
  static String PHONE_PAY_TRANSCATION_ID="";
 
  static RegisterCompany registerCompany=RegisterCompany();
  static String? FONTFAMILY=GoogleFonts.poppins().fontFamily;
  static int USERTYPE=0;

  static int AGENT=0;
  static int TRANSPOTER=1;
  static int MOVERSANDPACKeR=2;
  static int MANUFACTURE=3;
  static int TRUCKDRIVER=6;
}