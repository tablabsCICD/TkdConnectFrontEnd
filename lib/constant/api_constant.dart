import 'package:tkd_connect/model/response/userdata.dart';

class ApiConstant {
  static final String BASE_URL = "https://api.tkdost.com/tkd2/api/";

  // static final String BASE_URL="http://ec2-13-234-76-107.ap-south-1.compute.amazonaws.com:8080//tkd3/api/";
//static final String BASE_URL="http://ec2-13-234-76-107.ap-south-1.compute.amazonaws.com:8080/tkd3/api/";

  //static final String BASE_URL="http://ec2-13-234-76-107.ap-south-1.compute.amazonaws.com:8080/tkdConnect1/api/";
  //static final String BASE_URL="http://ec2-13-201-134-254.ap-south-1.compute.amazonaws.com:8080/tkd2/api/";

  // static String FULL_LOAD_ALL_CARD=BASE_URL + "allcards/fullLoad3";

  static String FULL_LOAD_BY_ID = BASE_URL + 'fullTruckLoad/';

  static String SEND_OTP(mobile) => BASE_URL + "sendOtp?mobileNos=$mobile";

  static String USER_FIND_BY_MOBILE(mobile) =>
      BASE_URL + "DeleteUser/getByMobileNumber?mobileNumber=$mobile";

  static String DIRECTORY(search) => BASE_URL + "directory?search=$search";

  static String DIRECTORYALL(page) => BASE_URL + "directory?page=$page";

  static String CHAT_USER_LIST(id) => BASE_URL + "chatBackup/userId?userId=$id";

  static String CHAT_USER_LIST_COMPANY(name) =>
      BASE_URL + "companyRegistration/ByName8?firstName=$name";

  static String IMG_UPLOAD = BASE_URL + "uploadImages";
  static String POST_CHAT = BASE_URL + "chatBackup";

  static String DIRECTORYFILTER = BASE_URL + "directory?";

  static String CREATE_GROUP = BASE_URL + "groups";
  static String UPDATE_GROUP = BASE_URL + "groups";
  static String DELETE_GROUP = BASE_URL + "groups?id=";

  static String GET_GROUP_LIST(userId) => BASE_URL + "groups/byUser/$userId";

  static String GET_USER_SOURCE_LIST(cityName) =>
      BASE_URL + "UserBySource?source=$cityName";

  static String ADD_GROUP_MEMBER = BASE_URL + "groupMembers/bulk";
  static String REMOVE_GROUP_MEMBER = BASE_URL + "groupMembers?id=";
  static String EDIT_GROUP_MEMBER = BASE_URL + "groupMembers/bulk";
  static String GROUP_MEMBER_LIST = BASE_URL + 'groupMembers/byGroupId/';

  // static String OTP_VERIFICATION(mobile,otp,deviceToken) => BASE_URL + "verifyOTP?mobileNumber=$mobile&otp=$otp&deviceId=$deviceToken";
  static String OTP_VERIFICATION(mobile, otp) =>
      BASE_URL + "VerifyOtp?mobileNumber=$mobile&otp=$otp";

  //static String MY_BIDS_PLACED(userName,page) => BASE_URL + "GetPostsAndBidsForUser?userName=$userName&privatePost=0&page=$page";
  static String MY_BIDS_PLACED(userName, page) =>
      BASE_URL +
      "GetPostsAndBidsForUserWithFilter?userName=$userName&privatePost=0&page=$page";

  static String AVG_BID(bidId) => BASE_URL + "GetAvgOfBid?id=${bidId}";

  static String VERFIED_USER(userId) =>
      BASE_URL + "companyRegistration/getUserVerified/${userId}";

  static String GET_ALL_CITY(page) =>
      BASE_URL + "get/cities/db/page/search?page=$page";

  static String GET_ALL_CITY_SERACH(city) =>
      BASE_URL + "get/cities/db/page/search?city=$city";

  static String ADD_CITY(state, city) =>
      BASE_URL + "set/cities/db?state=$state&city=$city";

  static String REGISTRATION = BASE_URL + "companyRegistration";
  static String PLACED_BID = BASE_URL + "biding";

  static String MY_ROUTE(id) => BASE_URL + "preferredroutes/userId/${id}";
  static String ROUTE = BASE_URL + "preferredroutes";

  static String MYPOSTBID(id, page) =>
      BASE_URL + "getOwnPostAndBid?userName=$id&page=$page";

  static String GETCOMMENTS(id) =>
      BASE_URL + "/getGerenalPostComments?generalPostId=$id";
  static String GIVE_RATING_REVIEWS = BASE_URL + "/ratings-reviews/save";

  static String HELPSUPPORTIKET = BASE_URL + "HelpAndSupportTicket";

  static String BUY_SELL_ALL_CARD(type, currentPage) =>
      BASE_URL + "allCards/buySell?type=${type}&&page=${currentPage}";
  static String POST_JOB = BASE_URL + "/postJob";
  static String GET_CURRENT_VERSION = BASE_URL + 'GetLatestVaersion';
  static String ADHAR_CREATE_TOKEN = BASE_URL + 'Aadhaar/authenticate';
  static String ADHAR_SEND_OTP = BASE_URL + 'Aadhaar/sendOpt';
  static String ADHAR_VERFIY_OTP = BASE_URL + 'Aadhaar/verifyOtp';
  static String POST_BUY_SELL = BASE_URL + "buySell";
  static String UPDATE_DEVICE_ID = BASE_URL + 'updateDeviceId';

  static String UPDATE_YOUR_PLAN(id, planId) =>
      BASE_URL + "updateValidTill?id=$id&plan=$planId";

  static String GET_BID_STATE(id, amount) =>
      BASE_URL + "GetPositionByAmountAndPostId?postId=$id&amount=$amount";

  //Dashboard Api Changes

  static String FULL_LOAD_AVILABLE(userId, page) =>
      BASE_URL +
      "dashboard/homepage/fullLoadAvailable?loggedUserId=${userId}&page=${page}&size=10";

  static String PART_LOAD_AVILABLE(userId, page) =>
      BASE_URL +
      "dashboard/homepage/PartLoadAvailable?loggedUserId=${userId}&page=${page}&size=10";

  static String FULL_LOAD_REQUIRED(userId, page) =>
      BASE_URL +
      "dashboard/homepage/fullLoadRequired?loggedUserId=${userId}&page=${page}&size=10";

  static String PART_LOAD_REQUIRED(userId, page) =>
      BASE_URL +
      "dashboard/homepage/partLoadRequired?loggedUserId=${userId}&page=${page}&size=10";

  static String General_POST_HOMEPAGE(userId, page) =>
      BASE_URL +
      "dashboard/homepage/General?loggedUserId=${userId}&page=${page}&size=10";

  static String JOBS_HOMEPAGE(userId, page) =>
      BASE_URL +
      "dashboard/homepage/Jobs?loggedUserId=${userId}&page=${page}&size=10";

  static String BUYSELL_HOMEPAGE(userId, page) =>
      BASE_URL +
      "dashboard/homepage/BuySell?loggedUserId=${userId}&page=${page}&size=10";
  static String HOMEPAGE_FILTER = BASE_URL + "dashboard/homepage/Search";
  static String FULL_LOAD_ALL_CARD = BASE_URL + "dashboard/homepage/posts";

  static String ALL_CARD(userId, page) =>
      BASE_URL +
      "dashboard/homepage/posts?loggedUserId=${userId}&page=${page}&size=10";

  //direcatory changes
  static String UPDATE_CHAT_LIST(connectId) => BASE_URL+"hatBackup/updateLoggedTime/${connectId}";

  static String GET_DIRECT_USER_LIST(page)=> BASE_URL+"directory/allDirectoryUser?page=${page}&size=30";
  static String GET_DIRECT_USER_DETAILS(userId)=> BASE_URL+"directory/detailsOfDirectoryUser?directoryUserId=${userId}";


  //chat changes

  static String CHAT_USER_LIST_DATE_SORT(id) => BASE_URL + "chatBackup/userIdSorted?userId=$id";
  static String CHAT_UPDATE_BY_TIME (id,sendTo)=> BASE_URL+"chatBackup/updateLoggedTime?id=$id&notificationSendTo=$sendTo";
}
