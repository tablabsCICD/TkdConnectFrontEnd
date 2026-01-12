import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart' as srt;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/datepicker.dart';

import '../../generated/l10n.dart';
import '../../model/request/post_load.dart';
import '../../model/response/post_upload.dart';
import '../../model/response/userdata.dart';
import '../../model/response/verified_user.dart';
import '../../screen/create_post/select_userlist_for_post.dart';
import '../../utils/colors.dart';
import '../../utils/razorpayload.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/paypostsheet.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum VoiceField {
  loadType,
  fromCity,
  toCity,
  cargoType,
  vehicleSize,
  loadWeight,
  mobile,
  email,
  instruction,
  paymentType,
}

class PostLoadProvider extends BaseProvider {
  VoiceField? activeVoiceField;
  bool isListening = false;
  double micLevel = 0.0;
  DateTime? _lastSpeechTime;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isAiLoading = false;
  String aiError = "";


  static const int silenceTimeoutMs = 2000;
  final FlutterTts _tts = FlutterTts();

  bool isSpeakingHint = false;

  Future<void> initVoice() async {
    try {
      LocalSharePreferences sharePreferences = LocalSharePreferences();
      String langCode = await sharePreferences.getLangCode();
      await _tts.setLanguage(langCode);
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
    } catch (e) {
      debugPrint("❌ TTS init failed: $e");
    }

    await _speech.initialize(
      onStatus: (status) => debugPrint("STT status: $status"),
      onError: (e) => debugPrint("STT error: $e"),
    );
  }

  Future<String> _voiceHintForField(VoiceField field) async {
    LocalSharePreferences sharePreferences = LocalSharePreferences();
    String langCode = await sharePreferences.getLangCode();
    return _voiceHints[langCode]?[field] ??
        _voiceHints["en"]![field] ??
        "Please speak now";
  }

  final Map<String, Map<VoiceField, String>> _voiceHints = {
    "en": {
      VoiceField.loadType: "Please say load type",
      VoiceField.fromCity: "Please say source city",
      VoiceField.toCity: "Please say destination city",
      VoiceField.cargoType: "Please say cargo type",
      VoiceField.vehicleSize: "Please say vehicle size",
      VoiceField.loadWeight: "Please say load weight in tons",
      VoiceField.paymentType: "Please say payment type",
      VoiceField.instruction: "Please say special instructions",
    },
    "hi": {
      VoiceField.loadType: "कृपया लोड का प्रकार बताएं",
      VoiceField.fromCity: "कृपया स्रोत शहर बताएं",
      VoiceField.toCity: "कृपया गंतव्य शहर बताएं",
      VoiceField.cargoType: "कृपया माल का प्रकार बताएं",
      VoiceField.vehicleSize: "कृपया वाहन का आकार बताएं",
      VoiceField.loadWeight: "कृपया वजन टन में बताएं",
      VoiceField.paymentType: "कृपया भुगतान का प्रकार बताएं",
      VoiceField.instruction: "कृपया विशेष निर्देश बताएं",
    },
    "mr": {
      VoiceField.loadType: "कृपया लोडचा प्रकार सांगा",
      VoiceField.fromCity: "कृपया सुरुवातीचे शहर सांगा",
      VoiceField.toCity: "कृपया गंतव्य शहर सांगा",
      VoiceField.cargoType: "कृपया मालाचा प्रकार सांगा",
      VoiceField.vehicleSize: "कृपया वाहनाचा आकार सांगा",
      VoiceField.loadWeight: "कृपया वजन टनमध्ये सांगा",
      VoiceField.paymentType: "कृपया पेमेंट प्रकार सांगा",
      VoiceField.instruction: "कृपया विशेष सूचना सांगा",
    },
    "kn_IN": {
      VoiceField.loadType: "ದಯವಿಟ್ಟು ಲೋಡ್ ಪ್ರಕಾರವನ್ನು ಹೇಳಿ",
      VoiceField.fromCity: "ದಯವಿಟ್ಟು ಮೂಲ ನಗರವನ್ನು ಹೇಳಿ",
      VoiceField.toCity: "ದಯವಿಟ್ಟು ಗಮ್ಯ ನಗರವನ್ನು ಹೇಳಿ",
      VoiceField.cargoType: "ದಯವಿಟ್ಟು ಸರಕು ಪ್ರಕಾರವನ್ನು ಹೇಳಿ",
      VoiceField.vehicleSize: "ದಯವಿಟ್ಟು ವಾಹನದ ಗಾತ್ರವನ್ನು ಹೇಳಿ",
      VoiceField.loadWeight: "ದಯವಿಟ್ಟು ತೂಕವನ್ನು ಟನ್‌ಗಳಲ್ಲಿ ಹೇಳಿ",
      VoiceField.paymentType: "ದಯವಿಟ್ಟು ಪಾವತಿ ಪ್ರಕಾರವನ್ನು ಹೇಳಿ",
      VoiceField.instruction: "ದಯವಿಟ್ಟು ವಿಶೇಷ ಸೂಚನೆಗಳನ್ನು ಹೇಳಿ",
    },
    "ta": {
      VoiceField.loadType: "தயவுசெய்து சரக்கு வகையை சொல்லுங்கள்",
      VoiceField.fromCity: "தயவுசெய்து ஆரம்ப நகரத்தை சொல்லுங்கள்",
      VoiceField.toCity: "தயவுசெய்து இலக்கு நகரத்தை சொல்லுங்கள்",
      VoiceField.cargoType: "தயவுசெய்து சரக்கு வகையை சொல்லுங்கள்",
      VoiceField.vehicleSize: "தயவுசெய்து வாகன அளவை சொல்லுங்கள்",
      VoiceField.loadWeight: "தயவுசெய்து எடையை டன்னில் சொல்லுங்கள்",
      VoiceField.paymentType: "தயவுசெய்து கட்டண வகையை சொல்லுங்கள்",
      VoiceField.instruction: "தயவுசெய்து சிறப்பு வழிமுறைகளை சொல்லுங்கள்",
    },
    "gu": {
      VoiceField.loadType: "કૃપા કરીને લોડનો પ્રકાર કહો",
      VoiceField.fromCity: "કૃપા કરીને સ્ત્રોત શહેર કહો",
      VoiceField.toCity: "કૃપા કરીને ગંતવ્ય શહેર કહો",
      VoiceField.cargoType: "કૃપા કરીને માલનો પ્રકાર કહો",
      VoiceField.vehicleSize: "કૃપા કરીને વાહનનું કદ કહો",
      VoiceField.loadWeight: "કૃપા કરીને વજન ટનમાં કહો",
      VoiceField.paymentType: "કૃપા કરીને ચુકવણી પ્રકાર કહો",
      VoiceField.instruction: "કૃપા કરીને ખાસ સૂચનાઓ કહો",
    },
    "te": {
      VoiceField.loadType: "దయచేసి లోడ్ రకం చెప్పండి",
      VoiceField.fromCity: "దయచేసి ప్రారంభ నగరం చెప్పండి",
      VoiceField.toCity: "దయచేసి గమ్య నగరం చెప్పండి",
      VoiceField.cargoType: "దయచేసి సరుకు రకం చెప్పండి",
      VoiceField.vehicleSize: "దయచేసి వాహన పరిమాణం చెప్పండి",
      VoiceField.loadWeight: "దయచేసి బరువును టన్నులలో చెప్పండి",
      VoiceField.paymentType: "దయచేసి చెల్లింపు రకం చెప్పండి",
      VoiceField.instruction: "దయచేసి ప్రత్యేక సూచనలు చెప్పండి",
    },
  };

  Future<bool> _initSpeech() async {
    final permitted = await _ensureMicPermission();
    if (!permitted) return false;

    final available = await _speech.initialize(
      onStatus: (status) => debugPrint("STT status: $status"),
      onError: (error) => debugPrint("STT error: $error"),
    );

    debugPrint("STT available: $available");
    return available;
  }

  Future<void> toggleMicForField(VoiceField field) async {
    if (isListening && activeVoiceField == field) {
      stopListening();
      return;
    }

    stopListening();

    try {
      await _speech.stop();
    } catch (_) {}

    try {
      await _tts.stop();
    } catch (e) {
      debugPrint("⚠️ TTS stop failed: $e");
    }

    activeVoiceField = field;
    isSpeakingHint = true;
    notifyListeners();
    LocalSharePreferences sharePreferences = LocalSharePreferences();
    String langCode = await sharePreferences.getLangCode();
    await _tts.setLanguage(
      langCode == "en" ? "en-IN" : langCode,
    );
    await _tts.speak(await _voiceHintForField(field));

    _tts.setCompletionHandler(() async {
      isSpeakingHint = false;
      notifyListeners();
      await _startListening(field);
    });
  }

  Future<void> _startListening(VoiceField field) async {
    final ready = await _initSpeech();
    if (!ready) {
      debugPrint("❌ STT not ready — cannot listen");
      return;
    }
    if (!_speech.isAvailable) {
      debugPrint("❌ STT not ready — cannot listen");
      return;
    }

    activeVoiceField = field;
    isListening = true;
    micLevel = 1;
    _lastSpeechTime = DateTime.now();

    notifyListeners();

    await _speech.listen(
      listenMode: stt.ListenMode.dictation,
      localeId: "auto",
      onSoundLevelChange: (level) {
        micLevel = level.clamp(0.0, 10.0);
        notifyListeners();
      },
      onResult: (srt.SpeechRecognitionResult result) {
        if (result.recognizedWords.isNotEmpty) {
          _onSpeechResult(result); // ✅ CALL THE FUNCTION
        }
      },
    );
  }

  void stopListening() {
    _speech.stop();
    isListening = false;
    micLevel = 0;
    activeVoiceField = null;

    notifyListeners();
  }


  /// Capitalize first letter of sentence
  String capitalizeSentence(String input) {
    if (input.trim().isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Capitalize each word (better for cities, dropdowns)
  String capitalizeWords(String input) {
    return input
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }

  void _onSpeechResult(srt.SpeechRecognitionResult result) async {
    final text = result.recognizedWords.trim();
    if (text.isEmpty) return;

    debugPrint("🎤 Heard: $text");
    _lastSpeechTime = DateTime.now();

    final formattedText = capitalizeWords(text);

    switch (activeVoiceField) {
      /// 🔽 LOAD TYPE
      case VoiceField.loadType:
        {
          String? match = _matchFromList(text, reqirement);


          if (match != null) {
            selectedRequriment = match;
            await _speakSelection(match);
          }else{
            selectedRequriment = formattedText;
          }
          break;
        }

      /// 🔽 CARGO TYPE
      case VoiceField.cargoType:
        {
          String? match = _matchFromList(text, cargoList);
          print(match);

          if (match != null) {
            selectedCargo = match;
            await _speakSelection(match);
          }else{
            selectedCargo = formattedText;
          }
          break;
        }

      /// 🔽 PAYMENT TYPE
      case VoiceField.paymentType:
        {
          String? match = _matchFromList(text, paymentList);

          if (match != null) {
            selectedPayment = match;
            await _speakSelection(match);
          }else{
            selectedCargo = formattedText;
          }
          break;
        }

      /// 🔽 FROM CITY
      case VoiceField.fromCity:
        sourceCity = capitalizeWords(text);
        break;

      /// 🔽 TO CITY
      case VoiceField.toCity:
        destinationCity = capitalizeWords(text);
        break;

      /// 📝 NORMAL FIELDS (UNCHANGED)
      case VoiceField.vehicleSize:
        vehicleSizeController.text = formattedText;
        break;

      case VoiceField.loadWeight:
        loadWeightController.text = formattedText;
        break;

      case VoiceField.mobile:
        final digits = text.replaceAll(RegExp(r'\D'), '');
        if (digits.length == 10) {
          mobileNumberController.text = digits;
        }
        break;

      case VoiceField.email:
        emailIdController.text = text.toLowerCase();
        break;

      case VoiceField.instruction:
        specialInstructionController.text = formattedText;
        break;

      default:
        break;
    }

    enble();
    notifyListeners();

    if (result.finalResult) {
      stopListening();
    }
  }


  final Map<String, String> _speechSynonyms = {
    // Load Type
    "फुल लोड": "Full Load",
    "पूर्ण लोड": "Full Load",
    "full load": "Full Load",

    "पार्ट लोड": "Part Load",
    "ardha load": "Part Load",
    "part load": "Part Load",

    // Cargo
    "लकड़ी": "Wooden Case",
    "लकडी": "Wooden Case",
    "wood": "Wooden Case",

    "ड्रम": "Drums",
    "drum": "Drums",

    "गन्नी": "Gunny Bags",
    "gunny": "Gunny Bags",

    "मशीन": "Machinery",
    "machine": "Machinery",

    // Payment
    "तुरंत": "Immediate",
    "immediate": "Immediate",

    "हफ्ता": "Weekly",
    "weekly": "Weekly",

    "पंधरवडा": "Fortnight",
    "fortnight": "Fortnight",
  };

  String _normalizeSpeech(String text) {
    return text.toLowerCase().trim();
  }

  String? _matchFromList(String spoken, List<String> list) {
    final normalized = _normalizeSpeech(spoken);

    // 1️⃣ Direct synonym match
    for (final entry in _speechSynonyms.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    // 2️⃣ Fallback fuzzy list match
    for (final item in list) {
      final itemNorm = item.toLowerCase();
      if (normalized.contains(itemNorm) || itemNorm.contains(normalized)) {
        return item;
      }
    }

    return null;
  }



  Future<void> _speakSelection(String value) async {
    try {
      LocalSharePreferences prefs = LocalSharePreferences();
      String langCode = await prefs.getLangCode();

      await _tts.setLanguage(langCode == "en" ? "en-IN" : langCode);
      await _tts.speak("I selected $value");
    } catch (_) {}
  }

  Future<bool> _ensureMicPermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      debugPrint("❌ Mic permanently denied");
      await openAppSettings();
      return false;
    }

    return false;
  }

  @override
  void dispose() {
    stopListening();
    _speech.cancel();
    super.dispose();
  }

  /* ===============================
     🧱 YOUR EXISTING LOGIC (UNCHANGED)
  ================================ */

  List<String> reqirement = ["Full Load", "Part Load"];
  List<String> reqirementVehicale = ["Full Load Vehicle", "Part Load Vehicle"];
  List<String> requirementList = ['I Want Vehicle', 'I Have Vehicle'];

  List<String> cargoList = [
    'Wooden Case',
    'Cartons',
    'Drums',
    'Gunny Bags',
    "Machinery",
    'Other'
  ];

  List<String> paymentList = ['Immediate', 'Fortnight', 'Weekly', 'Others'];

  String selectedRequriment = "Select Load";
  String selectedCargo = "Select Cargo Type";
  String selectedPayment = "Select Payment Type";
  String selectedGroup = "Select Group";
  String sourceCity = "Select Source City";
  String destinationCity = "Select Destination City";

  TextEditingController vehicleSizeController = TextEditingController();
  TextEditingController loadWeightController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  bool vehicaleSize = true;
  bool loadWieght = true;
  bool dnd = false;
  bool hideMyID = false;
  bool isRepeat = false;
  bool enbleButton = false;

  List<int> addedMemberIdList = [];
  List<String> listOptionShow = ["All User", "Group", "Verified user"];
  String selectOption = "Select Option";

  PostLoadProvider() : super('Ideal') {
    initData();
    initVoice();
  }

  initData() async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    emailIdController.text = user.content!.first.emailId!;
    mobileNumberController.text = user.content!.first.mobileNumber!.toString();
  }

  bool aiValidateBeforePost() {
    if (sourceCity == "Select One" || destinationCity == "Select One") {
      aiError = "Please select source and destination city";
      return false;
    }
    if (vehicleSizeController.text.isEmpty ||
        loadWeightController.text.isEmpty) {
      aiError = "Vehicle size and load weight required";
      return false;
    }
    return true;
  }

  /* ===============================
     🔐 VALIDATION (MERGED SAFELY)
  ================================ */

  checkValidation(BuildContext context) {
    if (!aiValidateBeforePost()) {
      ToastMessage.show(context, aiError);
      return;
    }

    if (vehicaleSize && loadWieght) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(S().postLoad),
          content:
              const Text('Are you sure you want to post this requirement?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => createPost(context),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      ToastMessage.show(context, "Please fill all information");
    }
  }

  List<String> images = [];

  uploadImage(BuildContext context) async {
    String image = await postImage(context);
    images.add(image);
    notifyListeners();
  }

  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<GroupMember> listAddedMember = [];

  getGroupListByUserId() async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
    print("Get Group List By User Id : $myUrl");
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    if (apiResponse.status == 200) {
      GroupListResponse groupListResponse =
          GroupListResponse.fromJson(apiResponse.response);
      groupListByUserId.clear();
      groupListName.clear();
      groupListByUserId
          .addAll(groupListResponse.content as Iterable<GroupData>);
      for (var element in groupListByUserId) {
        groupListName.add(element.groupName!);
      }
    }
    notifyListeners();
  }

  getGroupMember(int groupId) async {
    listAddedMember.clear();
    addedMemberIdList.clear();
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.GROUP_MEMBER_LIST + groupId.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);

    GroupMemberListResponse groupListModel =
        GroupMemberListResponse.fromJson(response.response);
    listAddedMember.addAll(groupListModel.content!);
    for (var element in listAddedMember) {
      addedMemberIdList.add(element.userId!);
    }
    print(addedMemberIdList.length);
    notifyListeners();
  }

  createPost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Have Vehicle"; // I Have Vehicle

    postLoad.instructions = specialInstructionController.text;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.content!.first.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = specialInstructionController.text;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedRequriment == 'Part Load' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.expireDate = expiryDateController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = ''; //images[0];
    postLoad.isRepeat = isRepeat == true ? 1 : 0;
    postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    postLoad.repeatEndDate = endDateController.text;
    postLoad.listOfUserIds = addedMemberIdList;
    postLoad.id = 0;

    ApiResponse response = await ApiHelper().postParameter(
        "${ApiConstant.BASE_URL}fullTruckLoad2", postLoad.toJson());
    print('The response status code: ${response.status}');

    if (response.status == 200) {
      PostUpload postUpload = PostUpload.fromJson(response.response);

      // First dialog logic
      Navigator.pop(context); // Close the first dialog

      // Delay showing the second dialog
      Future.microtask(() {
        _showConfirmationDialog(context);
      });

      if (postUpload.statusCode == 401) {
        ToastMessage.show(context, S().change_plan);
        callSubDailog(context, postLoad);
      } else {
        ToastMessage.show(context, S().postSubmittedSuccessfully);
        /* Navigator.pop(context);
        Navigator.pop(context, 1);*/
      }
    } else {
      ToastMessage.show(context, S().pleaseTryAgain);
    }
  }

  createVehiclePost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Want Vehicle";

    postLoad.instructions = specialInstructionController.text;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.content!.first.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = specialInstructionController.text;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedRequriment == 'Part Load Vehicle' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.expireDate = expiryDateController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = '';
    postLoad.isRepeat = isRepeat == true ? 1 : 0;
    postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    postLoad.repeatEndDate = endDateController.text;
    postLoad.listOfUserIds = addedMemberIdList;
    //postLoad.userList = null;

    ApiResponse response = await ApiHelper().postParameter(
        "${ApiConstant.BASE_URL}fullTruckLoad2", postLoad.toJson());
    print('the constand ${jsonEncode(postLoad.toJson())}');

    if (response.status == 200) {
      // ToastMessage.show(context, "Post submitted successfully!");
      // Navigator.pop(context);
      // Navigator.pop(context, 1);
      PostUpload postUpload = PostUpload.fromJson(response.response);
      Navigator.pop(context); // Close the first dialog

      // Delay showing the second dialog
      Future.microtask(() {
        _showConfirmationDialog(context);
      });

      if (postUpload.statusCode == 401) {
        ToastMessage.show(context, S().change_plan);
        callSubDailog(context, postLoad);
        // Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      } else {
        ToastMessage.show(context, S().postSubmittedSuccessfully);
        /*Navigator.pop(context);
        Navigator.pop(context, 1);*/
      }
    } else {
      ToastMessage.show(context, S().pleaseTryAgain);
    }
  }

  enble() {
    if (vehicleSizeController.text.isNotEmpty &&
        loadWeightController.text.isNotEmpty &&
        emailIdController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        specialInstructionController.text.isNotEmpty &&
        checkdropDown(selectedCargo) &&
        checkdropDown(selectedRequriment) &&
        checkdropDown(selectedPayment) &&
        checkdropDown(sourceCity) &&
        checkdropDown(destinationCity)) {
      enbleButton = true;
    } else {
      enbleButton = false;
    }
    notifyListeners();
  }

  checkdropDown(String val) {
    if (val.allMatches("Select One") == 0) {
      return false;
    } else {
      return true;
    }
  }

  setDate(String date) async {
    expiryDateController.text = date;
    notifyListeners();
  }

  setStartDate(String date) async {
    startDateController.text = date;
    notifyListeners();
  }

  setEndDate(String date) async {
    endDateController.text = date;
    notifyListeners();
  }

  selectedRequrimentType(int index) {
    selectedRequriment = reqirement[index];
    enble();
    notifyListeners();
  }

  selectedRequrimentVehicaleType(int index) {
    selectedRequriment = reqirementVehicale[index];
    enble();
    notifyListeners();
  }

  selectedCargoType(int index) {
    selectedCargo = cargoList[index];
    enble();
    notifyListeners();
  }

  selectedPaymentType(int index) {
    selectedPayment = paymentList[index];
    enble();
    notifyListeners();
  }

  selecteGroup(int index) async {
    addedMemberIdList.clear();
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
  }

  selecteOptiontoShow(int index, BuildContext context) async {
    notifyListeners();
    switch (index) {
      case 0:
        addedMemberIdList.clear();
        selectOption = listOptionShow[index];
        selectedGroup = listOptionShow[index];
        return;
      case 1:
        if (groupListName.isEmpty) {
          await getGroupListByUserId();
        }
        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
        int a = await itemBottomSheet.showIteamHieght(
            context, groupListName, "Select Group");

        selecteGroup(a);

        selectOption = listOptionShow[index];
        selectedGroup = listOptionShow[index];
        notifyListeners();
        return;

      case 2:
        if (sourceCity == "Select Source City") {
          ToastMessage.show(context, "Please select the source city ");
        } else {
          List<UserVerifiedData> verfiedUserList = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectUserForPostScreen(false, sourceCity)));
          if (verfiedUserList.isNotEmpty) {
            addedMemberIdList.clear();
            for (int i = 0; i < verfiedUserList.length; i++) {
              addedMemberIdList.add(verfiedUserList[i].id!);
            }
            selectOption = listOptionShow[index];
            selectedGroup = listOptionShow[index];
          }
        }

        return;
    }
  }

  selectedSourceCity(String city) {
    sourceCity = city;
    enble();
    notifyListeners();
  }

  selectedDestinationCity(String city) {
    destinationCity = city;
    enble();
    notifyListeners();
  }

/*  checkValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicaleSize = false;
    } else {
      vehicaleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    String;
    String selectedPayment = "Select One";

    String;
    if (selectedRequriment == "Select One") {
      ToastMessage.show(context, "Please Select Load Type");
    } else {
      if (sourceCity == "Select One") {
        ToastMessage.show(context, "Please Select From city");
      } else {
        if (destinationCity == "Select One") {
          ToastMessage.show(context, "Please Select To city");
        } else {
          if (selectedCargo == "Select One") {
            ToastMessage.show(context, "Please Select Cargo Type");
          } else {
            if (selectedGroup == "Select One") {
              ToastMessage.show(context, "Please Select Show Post To");
            } else {
              if (loadWieght && vehicaleSize) {
                //createPost(context);


                if(selectedGroup == "Select One"){

                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Post Load',style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),),
                        content: Text('Are you sure you want to post this requirement?',style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,),),
                          ),
                          TextButton(
                            onPressed: () {
                              createPost(context);

                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.green, fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

              } else {
                ToastMessage.show(context, "Please fill the all information");
              }
            }
          }
        }
      }
    }
    notifyListeners();
  }*/

  checkVehicaleValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicaleSize = false;
    } else {
      vehicaleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    if (selectedRequriment == "Select One") {
      ToastMessage.show(context, "Please Select Load Type");
    } else {
      if (sourceCity == "Select One") {
        ToastMessage.show(context, "Please Select From city");
      } else {
        if (destinationCity == "Select One") {
          ToastMessage.show(context, "Please Select To city");
        } else {
          if (selectedCargo == "Select One") {
            ToastMessage.show(context, "Please Select Cargo Type");
          } else {
            if (selectedGroup == "Select One") {
              ToastMessage.show(context, "Please Select Show Post To");
            } else {
              if (loadWieght && vehicaleSize) {
                // createVehiclePost(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        S().postLoad,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: Text(
                        S().saveMsg,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            S().no,
                            style: TextStyle(
                              color: ThemeColor.theme_blue,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            createVehiclePost(context);
                          },
                          child: Text(
                            S().yes,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ToastMessage.show(context, S().pleaseFillAllInformation);
              }
            }
          }
        }
      }
    }
    notifyListeners();
  }

  dndChange(bool val) {
    dnd = val;
    notifyListeners();
  }

  hideMyId(bool val) {
    hideMyID = val;
    notifyListeners();
  }

  repeatPostSwitch(bool val) {
    isRepeat = val;
    notifyListeners();
  }

  payment(BuildContext context, PostLoad postLoad) async {
    User user = await LocalSharePreferences().getLoginData();
    RazorPayClassLoad(context).initalPay(199, user.content!.first.mobileNumber!,
        user.content!.first.emailId!, postLoad);
  }

  void callSubDailog(BuildContext context, PostLoad postLoad) async {
    bool plan = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
              heightFactor: 0.6, child: PayPostSheet());
        });
    if (plan) {
      payment(
        context,
        postLoad,
      );
    } else {
      ToastMessage.show(context, S().pleaseTryAgain);
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S().importantNotice,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            S().noticeMsg,
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Ok',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
