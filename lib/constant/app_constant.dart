import 'package:google_fonts/google_fonts.dart';

import '../model/request/register_company.dart';

class AppConstant{

  static final String APP_VERSION = "3.0.4"; // 50

  static final String LOGIN_KEY="login";
  static final String CURRENT_GROUP="group";
  static final String GROUP_MEMBER="member";

  static final String LOGIN_BOOl="loginbool";

  static final String RESENT_SEARCH="search";
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