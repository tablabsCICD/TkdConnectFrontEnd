// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in`
  String get textlogin {
    return Intl.message(
      'Log in',
      name: 'textlogin',
      desc: '',
      args: [],
    );
  }

  /// `Login to continue`
  String get login_to_continue {
    return Intl.message(
      'Login to continue',
      name: 'login_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get OR {
    return Intl.message(
      'OR',
      name: 'OR',
      desc: '',
      args: [],
    );
  }

  /// `New User`
  String get NewUser {
    return Intl.message(
      'New User',
      name: 'NewUser',
      desc: '',
      args: [],
    );
  }

  /// ` Register Here`
  String get RegisterHere {
    return Intl.message(
      ' Register Here',
      name: 'RegisterHere',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get Send_OTP {
    return Intl.message(
      'Send OTP',
      name: 'Send_OTP',
      desc: '',
      args: [],
    );
  }

  /// `Enter mobile number`
  String get Enter_mobile_number {
    return Intl.message(
      'Enter mobile number',
      name: 'Enter_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Submit {
    return Intl.message(
      'Submit',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent to`
  String get OTP_sent_to {
    return Intl.message(
      'OTP sent to',
      name: 'OTP_sent_to',
      desc: '',
      args: [],
    );
  }

  /// `Change number`
  String get Change_number {
    return Intl.message(
      'Change number',
      name: 'Change_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get EnterOTP {
    return Intl.message(
      'Enter OTP',
      name: 'EnterOTP',
      desc: '',
      args: [],
    );
  }

  /// `Attempts`
  String get Attempts {
    return Intl.message(
      'Attempts',
      name: 'Attempts',
      desc: '',
      args: [],
    );
  }

  /// `Haven’t received OTP?`
  String get Havent_received_OTP {
    return Intl.message(
      'Haven’t received OTP?',
      name: 'Havent_received_OTP',
      desc: '',
      args: [],
    );
  }

  /// ` Resend OTP`
  String get Resend_OTP {
    return Intl.message(
      ' Resend OTP',
      name: 'Resend_OTP',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Next {
    return Intl.message(
      'Next',
      name: 'Next',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Personal details`
  String get personalDetails {
    return Intl.message(
      'Personal details',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Email-Id`
  String get email_id {
    return Intl.message(
      'Email-Id',
      name: 'email_id',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `eg.Rahul`
  String get egFristName {
    return Intl.message(
      'eg.Rahul',
      name: 'egFristName',
      desc: '',
      args: [],
    );
  }

  /// `eg.Shah`
  String get egLastName {
    return Intl.message(
      'eg.Shah',
      name: 'egLastName',
      desc: '',
      args: [],
    );
  }

  /// `eg.rahul.gmail.com`
  String get egMail {
    return Intl.message(
      'eg.rahul.gmail.com',
      name: 'egMail',
      desc: '',
      args: [],
    );
  }

  /// `9859XXXXX`
  String get egMobile {
    return Intl.message(
      '9859XXXXX',
      name: 'egMobile',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Business details`
  String get businessDetails {
    return Intl.message(
      'Business details',
      name: 'businessDetails',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyName {
    return Intl.message(
      'Company Name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `eg.Pune`
  String get egPune {
    return Intl.message(
      'eg.Pune',
      name: 'egPune',
      desc: '',
      args: [],
    );
  }

  /// `Add routes for better lead generation`
  String get addRoutes {
    return Intl.message(
      'Add routes for better lead generation',
      name: 'addRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Click the below button to add routes`
  String get clickAddRoutes {
    return Intl.message(
      'Click the below button to add routes',
      name: 'clickAddRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Select one`
  String get selectOne {
    return Intl.message(
      'Select one',
      name: 'selectOne',
      desc: '',
      args: [],
    );
  }

  /// `Select Business Type`
  String get business_type {
    return Intl.message(
      'Select Business Type',
      name: 'business_type',
      desc: '',
      args: [],
    );
  }

  /// `Agent/Broker`
  String get agentBroker {
    return Intl.message(
      'Agent/Broker',
      name: 'agentBroker',
      desc: '',
      args: [],
    );
  }

  /// `Transporter`
  String get transporter {
    return Intl.message(
      'Transporter',
      name: 'transporter',
      desc: '',
      args: [],
    );
  }

  /// `Packers and Movers`
  String get packersAndMovers {
    return Intl.message(
      'Packers and Movers',
      name: 'packersAndMovers',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer/Distributor/Trade`
  String get manufacturerDistributorTrade {
    return Intl.message(
      'Manufacturer/Distributor/Trade',
      name: 'manufacturerDistributorTrade',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `MY QUOTES`
  String get myQuotes {
    return Intl.message(
      'MY QUOTES',
      name: 'myQuotes',
      desc: '',
      args: [],
    );
  }

  /// `Directory`
  String get directory {
    return Intl.message(
      'Directory',
      name: 'directory',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Create a post`
  String get createPost {
    return Intl.message(
      'Create a post',
      name: 'createPost',
      desc: '',
      args: [],
    );
  }

  /// `Hello! We are here to elevate your logistics experience. Let us be your logistics assistance and your business needs will be fulfilled seamlessly.`
  String get introOneDescription {
    return Intl.message(
      'Hello! We are here to elevate your logistics experience. Let us be your logistics assistance and your business needs will be fulfilled seamlessly.',
      name: 'introOneDescription',
      desc: '',
      args: [],
    );
  }

  /// `Your needs are our skills. Let us combine the two and rise up together`
  String get introTwoDescription {
    return Intl.message(
      'Your needs are our skills. Let us combine the two and rise up together',
      name: 'introTwoDescription',
      desc: '',
      args: [],
    );
  }

  /// `With our wide network, we shall help you reach wider.`
  String get introThreeDescription {
    return Intl.message(
      'With our wide network, we shall help you reach wider.',
      name: 'introThreeDescription',
      desc: '',
      args: [],
    );
  }

  /// `My Posts`
  String get myPost {
    return Intl.message(
      'My Posts',
      name: 'myPost',
      desc: '',
      args: [],
    );
  }

  /// `Jobs`
  String get jobs {
    return Intl.message(
      'Jobs',
      name: 'jobs',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle sell/buy`
  String get buySell {
    return Intl.message(
      'Vehicle sell/buy',
      name: 'buySell',
      desc: '',
      args: [],
    );
  }

  /// `Get verified`
  String get getVerified {
    return Intl.message(
      'Get verified',
      name: 'getVerified',
      desc: '',
      args: [],
    );
  }

  /// `App setting`
  String get appSetting {
    return Intl.message(
      'App setting',
      name: 'appSetting',
      desc: '',
      args: [],
    );
  }

  /// `Help & support`
  String get helpSupport {
    return Intl.message(
      'Help & support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to Log Out.`
  String get logoutMsg {
    return Intl.message(
      'Do you want to Log Out.',
      name: 'logoutMsg',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Edit your profile`
  String get editYourProfile {
    return Intl.message(
      'Edit your profile',
      name: 'editYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Show all quote`
  String get showAllQuotes {
    return Intl.message(
      'Show all quote',
      name: 'showAllQuotes',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this post.`
  String get deleteMsg {
    return Intl.message(
      'Do you want to delete this post.',
      name: 'deleteMsg',
      desc: '',
      args: [],
    );
  }

  /// `Post a job`
  String get postAJob {
    return Intl.message(
      'Post a job',
      name: 'postAJob',
      desc: '',
      args: [],
    );
  }

  /// `Post Job`
  String get postJob {
    return Intl.message(
      'Post Job',
      name: 'postJob',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `eg. Senior traffic manager`
  String get egSeniorManager {
    return Intl.message(
      'eg. Senior traffic manager',
      name: 'egSeniorManager',
      desc: '',
      args: [],
    );
  }

  /// `Job title`
  String get jobTitle {
    return Intl.message(
      'Job title',
      name: 'jobTitle',
      desc: '',
      args: [],
    );
  }

  /// `eg. Manage inquiries`
  String get egManageInquiries {
    return Intl.message(
      'eg. Manage inquiries',
      name: 'egManageInquiries',
      desc: '',
      args: [],
    );
  }

  /// `Salary`
  String get salary {
    return Intl.message(
      'Salary',
      name: 'salary',
      desc: '',
      args: [],
    );
  }

  /// `eg. 1LPA -2 LPA`
  String get egSal {
    return Intl.message(
      'eg. 1LPA -2 LPA',
      name: 'egSal',
      desc: '',
      args: [],
    );
  }

  /// `Job description`
  String get jobDes {
    return Intl.message(
      'Job description',
      name: 'jobDes',
      desc: '',
      args: [],
    );
  }

  /// `Job description`
  String get egJobDes {
    return Intl.message(
      'Job description',
      name: 'egJobDes',
      desc: '',
      args: [],
    );
  }

  /// `Specify required experience`
  String get specifyRequiredExperience {
    return Intl.message(
      'Specify required experience',
      name: 'specifyRequiredExperience',
      desc: '',
      args: [],
    );
  }

  /// `Create job post`
  String get createJobPost {
    return Intl.message(
      'Create job post',
      name: 'createJobPost',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get experies {
    return Intl.message(
      'Experience',
      name: 'experies',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Search place`
  String get searchPlace {
    return Intl.message(
      'Search place',
      name: 'searchPlace',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get changeLanguage {
    return Intl.message(
      'Change language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get on {
    return Intl.message(
      'On',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get off {
    return Intl.message(
      'Off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `Traffic`
  String get traffic {
    return Intl.message(
      'Traffic',
      name: 'traffic',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `Raise a ticket`
  String get raiseATicket {
    return Intl.message(
      'Raise a ticket',
      name: 'raiseATicket',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Login issue`
  String get loginIssue {
    return Intl.message(
      'Login issue',
      name: 'loginIssue',
      desc: '',
      args: [],
    );
  }

  /// `App crash`
  String get appCrash {
    return Intl.message(
      'App crash',
      name: 'appCrash',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Choose a topic`
  String get chooseATopic {
    return Intl.message(
      'Choose a topic',
      name: 'chooseATopic',
      desc: '',
      args: [],
    );
  }

  /// `characters max`
  String get charactersMax {
    return Intl.message(
      'characters max',
      name: 'charactersMax',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Topic`
  String get pleaseSelectTopic {
    return Intl.message(
      'Please Select Topic',
      name: 'pleaseSelectTopic',
      desc: '',
      args: [],
    );
  }

  /// `characters remaining`
  String get charactersRemaining {
    return Intl.message(
      'characters remaining',
      name: 'charactersRemaining',
      desc: '',
      args: [],
    );
  }

  /// `Explain your concern`
  String get explainYourConcern {
    return Intl.message(
      'Explain your concern',
      name: 'explainYourConcern',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get saveChange {
    return Intl.message(
      'Save changes',
      name: 'saveChange',
      desc: '',
      args: [],
    );
  }

  /// `Business info`
  String get businessInfo {
    return Intl.message(
      'Business info',
      name: 'businessInfo',
      desc: '',
      args: [],
    );
  }

  /// `Personal info`
  String get personalInfo {
    return Intl.message(
      'Personal info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Search users & companies`
  String get searchUsersCompanies {
    return Intl.message(
      'Search users & companies',
      name: 'searchUsersCompanies',
      desc: '',
      args: [],
    );
  }

  /// `My routes`
  String get myRoutes {
    return Intl.message(
      'My routes',
      name: 'myRoutes',
      desc: '',
      args: [],
    );
  }

  /// `All routes`
  String get allRoutes {
    return Intl.message(
      'All routes',
      name: 'allRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Verified users`
  String get verifiedUsers {
    return Intl.message(
      'Verified users',
      name: 'verifiedUsers',
      desc: '',
      args: [],
    );
  }

  /// `View profile`
  String get viewProfile {
    return Intl.message(
      'View profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `All users`
  String get allUsers {
    return Intl.message(
      'All users',
      name: 'allUsers',
      desc: '',
      args: [],
    );
  }

  /// `About company`
  String get aboutCompany {
    return Intl.message(
      'About company',
      name: 'aboutCompany',
      desc: '',
      args: [],
    );
  }

  /// `Operating routes`
  String get operatingRoutes {
    return Intl.message(
      'Operating routes',
      name: 'operatingRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Quote you placed`
  String get quotesYouPlaced {
    return Intl.message(
      'Quote you placed',
      name: 'quotesYouPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Quote you received`
  String get quotesYouReceived {
    return Intl.message(
      'Quote you received',
      name: 'quotesYouReceived',
      desc: '',
      args: [],
    );
  }

  /// `Quote price`
  String get quotesPrice {
    return Intl.message(
      'Quote price',
      name: 'quotesPrice',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw quote`
  String get withdrawQuotes {
    return Intl.message(
      'Withdraw quote',
      name: 'withdrawQuotes',
      desc: '',
      args: [],
    );
  }

  /// `No Record Found`
  String get noRecordFound {
    return Intl.message(
      'No Record Found',
      name: 'noRecordFound',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Quote now`
  String get quotesNow {
    return Intl.message(
      'Quote now',
      name: 'quotesNow',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Enter quote amount`
  String get enterQuoteAmount {
    return Intl.message(
      'Enter quote amount',
      name: 'enterQuoteAmount',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `eg.title of post`
  String get egTitleofPost {
    return Intl.message(
      'eg.title of post',
      name: 'egTitleofPost',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get subtitle {
    return Intl.message(
      'Subtitle',
      name: 'subtitle',
      desc: '',
      args: [],
    );
  }

  /// `eg.Sub title`
  String get egSubTitle {
    return Intl.message(
      'eg.Sub title',
      name: 'egSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add images at just ₹0`
  String get addImagesAt {
    return Intl.message(
      'Add images at just ₹0',
      name: 'addImagesAt',
      desc: '',
      args: [],
    );
  }

  /// `Post`
  String get post {
    return Intl.message(
      'Post',
      name: 'post',
      desc: '',
      args: [],
    );
  }

  /// `Load`
  String get loads {
    return Intl.message(
      'Load',
      name: 'loads',
      desc: '',
      args: [],
    );
  }

  /// `From City`
  String get fromCity {
    return Intl.message(
      'From City',
      name: 'fromCity',
      desc: '',
      args: [],
    );
  }

  /// `To City`
  String get toCity {
    return Intl.message(
      'To City',
      name: 'toCity',
      desc: '',
      args: [],
    );
  }

  /// `Cargo Type`
  String get cargoType {
    return Intl.message(
      'Cargo Type',
      name: 'cargoType',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle size`
  String get vehicleSize {
    return Intl.message(
      'Vehicle size',
      name: 'vehicleSize',
      desc: '',
      args: [],
    );
  }

  /// `Load Weight`
  String get loadWeight {
    return Intl.message(
      'Load Weight',
      name: 'loadWeight',
      desc: '',
      args: [],
    );
  }

  /// `Special Instruction`
  String get specialInstruction {
    return Intl.message(
      'Special Instruction',
      name: 'specialInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentType {
    return Intl.message(
      'Payment Type',
      name: 'paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Post Load`
  String get postLoad {
    return Intl.message(
      'Post Load',
      name: 'postLoad',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get vehicle {
    return Intl.message(
      'Vehicle',
      name: 'vehicle',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Sponsered`
  String get sponsered {
    return Intl.message(
      'Sponsered',
      name: 'sponsered',
      desc: '',
      args: [],
    );
  }

  /// `Truck Driver`
  String get truckDriver {
    return Intl.message(
      'Truck Driver',
      name: 'truckDriver',
      desc: '',
      args: [],
    );
  }

  /// `Load Post Issue`
  String get createPostLoadIssue {
    return Intl.message(
      'Load Post Issue',
      name: 'createPostLoadIssue',
      desc: '',
      args: [],
    );
  }

  /// `Buy/Sell Issue`
  String get buysellIssue {
    return Intl.message(
      'Buy/Sell Issue',
      name: 'buysellIssue',
      desc: '',
      args: [],
    );
  }

  /// `Create Job Issue`
  String get jobIssue {
    return Intl.message(
      'Create Job Issue',
      name: 'jobIssue',
      desc: '',
      args: [],
    );
  }

  /// `Share application and Earn Surprise Gift`
  String get shareapp {
    return Intl.message(
      'Share application and Earn Surprise Gift',
      name: 'shareapp',
      desc: '',
      args: [],
    );
  }

  /// `other`
  String get other {
    return Intl.message(
      'other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Registration - Personal details`
  String get registration_personal {
    return Intl.message(
      'Registration - Personal details',
      name: 'registration_personal',
      desc: '',
      args: [],
    );
  }

  /// `Re-post`
  String get Re_post {
    return Intl.message(
      'Re-post',
      name: 'Re_post',
      desc: '',
      args: [],
    );
  }

  /// `Choose Plan`
  String get change_plan {
    return Intl.message(
      'Choose Plan',
      name: 'change_plan',
      desc: '',
      args: [],
    );
  }

  /// `Type of Company`
  String get type_of_company {
    return Intl.message(
      'Type of Company',
      name: 'type_of_company',
      desc: '',
      args: [],
    );
  }

  /// `Recent searches`
  String get recent_search {
    return Intl.message(
      'Recent searches',
      name: 'recent_search',
      desc: '',
      args: [],
    );
  }

  /// `Search here`
  String get search_here {
    return Intl.message(
      'Search here',
      name: 'search_here',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Rate and Review`
  String get rateAndReviewApp {
    return Intl.message(
      'Rate and Review',
      name: 'rateAndReviewApp',
      desc: '',
      args: [],
    );
  }

  /// `Rate This App.`
  String get rate_this_app {
    return Intl.message(
      'Rate This App.',
      name: 'rate_this_app',
      desc: '',
      args: [],
    );
  }

  /// `How do you rate our app ?`
  String get how_do_you_rate_app {
    return Intl.message(
      'How do you rate our app ?',
      name: 'how_do_you_rate_app',
      desc: '',
      args: [],
    );
  }

  /// `RATE`
  String get rate {
    return Intl.message(
      'RATE',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `MAYBE LATER`
  String get may_be_letter {
    return Intl.message(
      'MAYBE LATER',
      name: 'may_be_letter',
      desc: '',
      args: [],
    );
  }

  /// `Get in tounch`
  String get getInTouch {
    return Intl.message(
      'Get in tounch',
      name: 'getInTouch',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Repost`
  String get re_post {
    return Intl.message(
      'Repost',
      name: 're_post',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Apply now`
  String get applyNow {
    return Intl.message(
      'Apply now',
      name: 'applyNow',
      desc: '',
      args: [],
    );
  }

  /// `Show post to`
  String get groupType {
    return Intl.message(
      'Show post to',
      name: 'groupType',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Condition`
  String get terms_condition {
    return Intl.message(
      'Terms & Condition',
      name: 'terms_condition',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyAndPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyAndPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get creategroup {
    return Intl.message(
      'Create Group',
      name: 'creategroup',
      desc: '',
      args: [],
    );
  }

  /// `Edit Post`
  String get editPost {
    return Intl.message(
      'Edit Post',
      name: 'editPost',
      desc: '',
      args: [],
    );
  }

  /// `City Interchange`
  String get cityInterchange {
    return Intl.message(
      'City Interchange',
      name: 'cityInterchange',
      desc: '',
      args: [],
    );
  }

  /// `Bulk Load Upload `
  String get bulkLoadUpload {
    return Intl.message(
      'Bulk Load Upload ',
      name: 'bulkLoadUpload',
      desc: '',
      args: [],
    );
  }

  /// `Show Post to`
  String get showPostto {
    return Intl.message(
      'Show Post to',
      name: 'showPostto',
      desc: '',
      args: [],
    );
  }

  /// `Before Upload Excel,Click Here to Download Format`
  String get downloadExl {
    return Intl.message(
      'Before Upload Excel,Click Here to Download Format',
      name: 'downloadExl',
      desc: '',
      args: [],
    );
  }

  /// `Upload Load`
  String get uploadLoad {
    return Intl.message(
      'Upload Load',
      name: 'uploadLoad',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiryDate {
    return Intl.message(
      'Expiry Date',
      name: 'expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Quote Reason`
  String get quoteReason {
    return Intl.message(
      'Quote Reason',
      name: 'quoteReason',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to complete this post.`
  String get completeMsg {
    return Intl.message(
      'Do you want to complete this post.',
      name: 'completeMsg',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message(
      'Expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }

  /// `I Want Vehicle`
  String get iWantVehicle {
    return Intl.message(
      'I Want Vehicle',
      name: 'iWantVehicle',
      desc: '',
      args: [],
    );
  }

  /// `I Have Vehicle`
  String get iHaveVehicle {
    return Intl.message(
      'I Have Vehicle',
      name: 'iHaveVehicle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'kn', countryCode: 'IN'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
