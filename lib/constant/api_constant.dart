class ApiConstant {


  static final String BASE_URL="https://api.tkdost.com/tkd3/api/";
  //static final String BASE_URL="http://ec2-13-234-76-107.ap-south-1.compute.amazonaws.com:8080/tkdConnect1/api/";

 // static String FULL_LOAD_ALL_CARD=BASE_URL + "allcards/fullLoad3";
  static String FULL_LOAD_ALL_CARD=BASE_URL + "dashboard/homepage/posts";
  static String SEND_OTP(mobile) => BASE_URL + "SendOTP?mobileNumber=$mobile";
  static String USER_FIND_BY_MOBILE(mobile) => BASE_URL + "DeleteUser/getByMobileNumber?mobileNumber=$mobile";
  static String DIRECTORY(search) => BASE_URL + "directory?search=$search";
  static String DIRECTORYALL(page) => BASE_URL + "directory?page=$page";

  static String OTP_VERIFICATION(mobile,otp,deviceToken) => BASE_URL + "verifyOTP?mobileNumber=$mobile&otp=$otp&deviceId=$deviceToken";
  static String MY_BIDS_PLACED(userName,page) => BASE_URL + "GetPostsAndBidsForUser?userName=$userName&privatePost=0&page=$page";
  static String GET_ALL_CITY=BASE_URL+"get/cities/db";
  static String REGISTRATION = BASE_URL + "companyRegistration";
  static String PLACED_BID=BASE_URL+"biding";
  static String MY_ROUTE(id)=> BASE_URL + "preferredroutes/userId/${id}";
  static String ROUTE = BASE_URL + "preferredroutes";
  static String MYPOSTBID(id,page) => BASE_URL + "getOwnPostAndBid?userName=$id&page=$page";
  static String HELPSUPPORTIKET = BASE_URL + "HelpAndSupportTicket";
  static String BUY_SELL_ALL_CARD (type,currentPage)=> BASE_URL + "allCards/buySell?type=${type}&&page=${currentPage}";
  static String POST_JOB = BASE_URL + "/postJob";
  static String GET_CURRENT_VERSION = BASE_URL + 'GetLatestVaersion';







}