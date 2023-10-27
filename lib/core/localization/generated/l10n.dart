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
// ignore_for_file: avoid_redundant_argument_values

class AppLocalizations {
  AppLocalizations();
  
  static AppLocalizations current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      AppLocalizations.current = AppLocalizations();
      
      return AppLocalizations.current;
    });
  } 

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Activity`
  String get activity {
    return Intl.message(
      'Activity',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `A curated list of resources you have access too.`
  String get aCuratedListOfResources {
    return Intl.message(
      'A curated list of resources you have access too.',
      name: 'aCuratedListOfResources',
      desc: '',
      args: [],
    );
  }

  /// `Add Log`
  String get addLog {
    return Intl.message(
      'Add Log',
      name: 'addLog',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `{articleCount, plural, one{1 Article} other{{articleCount} Articles}}`
  String articleCount(num articleCount) {
    return Intl.plural(
      articleCount,
      one: '1 Article',
      other: '$articleCount Articles',
      name: 'articleCount',
      desc: '',
      args: [articleCount],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get children {
    return Intl.message(
      'Children',
      name: 'children',
      desc: '',
      args: [],
    );
  }

  /// `Click below to login and access the app.`
  String get clickBelowToLogin {
    return Intl.message(
      'Click below to login and access the app.',
      name: 'clickBelowToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Connecting Parents & Agencies for better foster care.`
  String get connectingParentsAndAgencies {
    return Intl.message(
      'Connecting Parents & Agencies for better foster care.',
      name: 'connectingParentsAndAgencies',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Continue without account`
  String get continueWithoutAccount {
    return Intl.message(
      'Continue without account',
      name: 'continueWithoutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your CPA’s email and we will send them information on how to get started.`
  String get enterCpasEmailDescription {
    return Intl.message(
      'Enter your CPA’s email and we will send them information on how to get started.',
      name: 'enterCpasEmailDescription',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
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

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `FosterShare`
  String get fosterShare {
    return Intl.message(
      'FosterShare',
      name: 'fosterShare',
      desc: '',
      args: [],
    );
  }

  /// `Help/FAQ`
  String get helpFAQ {
    return Intl.message(
      'Help/FAQ',
      name: 'helpFAQ',
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

  /// `How to use FosterShare`
  String get howToUseFosterShare {
    return Intl.message(
      'How to use FosterShare',
      name: 'howToUseFosterShare',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get invalidPassword {
    return Intl.message(
      'Invalid Password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Keep in touch with your case manager`
  String get keepInTouchWithYourCaseManager {
    return Intl.message(
      'Keep in touch with your case manager',
      name: 'keepInTouchWithYourCaseManager',
      desc: '',
      args: [],
    );
  }

  /// `Always have the ability to contact your case manager. Need help? Just get in touch!`
  String get keepInTouchWithYourCaseManagerDescription {
    return Intl.message(
      'Always have the ability to contact your case manager. Need help? Just get in touch!',
      name: 'keepInTouchWithYourCaseManagerDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keep track of important dates`
  String get keepTrackOfImportantDates {
    return Intl.message(
      'Keep track of important dates',
      name: 'keepTrackOfImportantDates',
      desc: '',
      args: [],
    );
  }

  /// `With trainings and events sent right to your calendar, you will never miss an important date. And reminders will help keep you up-to-date, wherever you are.`
  String get keepTrackOfImportantDatesDescription {
    return Intl.message(
      'With trainings and events sent right to your calendar, you will never miss an important date. And reminders will help keep you up-to-date, wherever you are.',
      name: 'keepTrackOfImportantDatesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keep track of your routine logs`
  String get keepTrackOfYourRoutineLogs {
    return Intl.message(
      'Keep track of your routine logs',
      name: 'keepTrackOfYourRoutineLogs',
      desc: '',
      args: [],
    );
  }

  /// `We've simplified the process, so daily documentation is quick and easy. And with easy views, you can look back over time to spot behavior trends and track successes.`
  String get keepTrackOfYourRoutineLogsDescription {
    return Intl.message(
      'We\'ve simplified the process, so daily documentation is quick and easy. And with easy views, you can look back over time to spot behavior trends and track successes.',
      name: 'keepTrackOfYourRoutineLogsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Let your CPA know about FosterShare`
  String get letYourCpaKnowAboutFosterShare {
    return Intl.message(
      'Let your CPA know about FosterShare',
      name: 'letYourCpaKnowAboutFosterShare',
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

  /// `Local Resources`
  String get localResources {
    return Intl.message(
      'Local Resources',
      name: 'localResources',
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

  /// `My Children`
  String get myChildren {
    return Intl.message(
      'My Children',
      name: 'myChildren',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notificationSettings {
    return Intl.message(
      'Notification Settings',
      name: 'notificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Occupation`
  String get occupation {
    return Intl.message(
      'Occupation',
      name: 'occupation',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Popular Articles`
  String get popularArticles {
    return Intl.message(
      'Popular Articles',
      name: 'popularArticles',
      desc: '',
      args: [],
    );
  }

  /// `Popular Topics`
  String get popularTopics {
    return Intl.message(
      'Popular Topics',
      name: 'popularTopics',
      desc: '',
      args: [],
    );
  }

  /// `Powered By Miracle Foundation`
  String get poweredByMiracelFoundation {
    return Intl.message(
      'Powered By Miracle Foundation',
      name: 'poweredByMiracelFoundation',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Read Now`
  String get readNow {
    return Intl.message(
      'Read Now',
      name: 'readNow',
      desc: '',
      args: [],
    );
  }

  /// `Received an invite?`
  String get receievedAnInvite {
    return Intl.message(
      'Received an invite?',
      name: 'receievedAnInvite',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Resources at your fingertips`
  String get resourcesAtYourFingertips {
    return Intl.message(
      'Resources at your fingertips',
      name: 'resourcesAtYourFingertips',
      desc: '',
      args: [],
    );
  }

  /// `From moral support to the newest service, connect with much needed local resources who can quickly support you when you need it most. And browse foster community blogs and articles for the latest advice.`
  String get resourcesAtYourFingertipsDescription {
    return Intl.message(
      'From moral support to the newest service, connect with much needed local resources who can quickly support you when you need it most. And browse foster community blogs and articles for the latest advice.',
      name: 'resourcesAtYourFingertipsDescription',
      desc: '',
      args: [],
    );
  }

  /// `{resourceCount, plural, one{1 Resource} other{{resourceCount} Resources}}`
  String resourceCount(num resourceCount) {
    return Intl.plural(
      resourceCount,
      one: '1 Resource',
      other: '$resourceCount Resources',
      name: 'resourceCount',
      desc: '',
      args: [resourceCount],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message(
      'Share App',
      name: 'shareApp',
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

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
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

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Visit Now`
  String get visitNow {
    return Intl.message(
      'Visit Now',
      name: 'visitNow',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to FosterShare, access your account by filling in your credentials below.`
  String get welcomeToFosterShare {
    return Intl.message(
      'Welcome to FosterShare, access your account by filling in your credentials below.',
      name: 'welcomeToFosterShare',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Update Required`
  String get updateRequired {
    return Intl.message(
      'Update Required',
      name: 'updateRequired',
      desc: '',
      args: [],
    );
  }

  /// `Update Recommended`
  String get updateRecommended {
    return Intl.message(
      'Update Recommended',
      name: 'updateRecommended',
      desc: '',
      args: [],
    );
  }

  /// `Please click below to update the app.`
  String get clickToUpdate {
    return Intl.message(
      'Please click below to update the app.',
      name: 'clickToUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get notNow {
    return Intl.message(
      'Not now',
      name: 'notNow',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in as a foster parent to use the app.`
  String get signInAsFoster {
    return Intl.message(
      'Please sign in as a foster parent to use the app.',
      name: 'signInAsFoster',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Success`
  String get signInSuccess {
    return Intl.message(
      'Sign In Success',
      name: 'signInSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Welcome To The FosterShare Family!`
  String get welcomeToFSFamily {
    return Intl.message(
      'Welcome To The FosterShare Family!',
      name: 'welcomeToFSFamily',
      desc: '',
      args: [],
    );
  }

  /// `We are here to help you navigate this adventure every step of the way. `
  String get hereToHelpNavigate {
    return Intl.message(
      'We are here to help you navigate this adventure every step of the way. ',
      name: 'hereToHelpNavigate',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you have no children at this time. Please tap below to check again.`
  String get noChildren {
    return Intl.message(
      'Sorry, you have no children at this time. Please tap below to check again.',
      name: 'noChildren',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get reload {
    return Intl.message(
      'Reload',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `You currently have no logs. Please tap below to submit your first log.`
  String get noLog {
    return Intl.message(
      'You currently have no logs. Please tap below to submit your first log.',
      name: 'noLog',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem loading children and parents details. Please try again.`
  String get errorLoadingChildren {
    return Intl.message(
      'There was a problem loading children and parents details. Please try again.',
      name: 'errorLoadingChildren',
      desc: '',
      args: [],
    );
  }

  /// `Log Complete`
  String get logComplete {
    return Intl.message(
      'Log Complete',
      name: 'logComplete',
      desc: '',
      args: [],
    );
  }

  /// `Great job, you’re becoming the ultimate foster parent!`
  String get ultimateFosterParent {
    return Intl.message(
      'Great job, you’re becoming the ultimate foster parent!',
      name: 'ultimateFosterParent',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get selectRating {
    return Intl.message(
      'Please select a rating',
      name: 'selectRating',
      desc: '',
      args: [],
    );
  }

  /// `Please add comments`
  String get addComments {
    return Intl.message(
      'Please add comments',
      name: 'addComments',
      desc: '',
      args: [],
    );
  }

  /// `Please select an option`
  String get selectOption {
    return Intl.message(
      'Please select an option',
      name: 'selectOption',
      desc: '',
      args: [],
    );
  }

  /// `Please select a choice`
  String get selectChoice {
    return Intl.message(
      'Please select a choice',
      name: 'selectChoice',
      desc: '',
      args: [],
    );
  }

  /// `Option not selected`
  String get optionNotSelected {
    return Intl.message(
      'Option not selected',
      name: 'optionNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Please enter what happened on the visit.`
  String get whatHappenDuringVisit {
    return Intl.message(
      'Please enter what happened on the visit.',
      name: 'whatHappenDuringVisit',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Next Step`
  String get nextStep {
    return Intl.message(
      'Next Step',
      name: 'nextStep',
      desc: '',
      args: [],
    );
  }

  /// `Were there any behavioral issues?`
  String get behaviorQuestion {
    return Intl.message(
      'Were there any behavioral issues?',
      name: 'behaviorQuestion',
      desc: '',
      args: [],
    );
  }

  /// `List behaviors, issues, etc. that happened today.`
  String get behaviorSubQuestion {
    return Intl.message(
      'List behaviors, issues, etc. that happened today.',
      name: 'behaviorSubQuestion',
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

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `What happened?`
  String get whatHappened {
    return Intl.message(
      'What happened?',
      name: 'whatHappened',
      desc: '',
      args: [],
    );
  }

  /// `Describe the situation in a few words…`
  String get describeSituation {
    return Intl.message(
      'Describe the situation in a few words…',
      name: 'describeSituation',
      desc: '',
      args: [],
    );
  }

  /// `Biological family contact?`
  String get bioFamQuestion {
    return Intl.message(
      'Biological family contact?',
      name: 'bioFamQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Did the child visit their biological family?`
  String get bioFamSubQuestion {
    return Intl.message(
      'Did the child visit their biological family?',
      name: 'bioFamSubQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Describe the 'visit' in a few words.`
  String get describeVisit {
    return Intl.message(
      'Describe the \'visit\' in a few words.',
      name: 'describeVisit',
      desc: '',
      args: [],
    );
  }

  /// `Child’s mood today?`
  String get childMoodQuesion {
    return Intl.message(
      'Child’s mood today?',
      name: 'childMoodQuesion',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `How did the day go?`
  String get dayRatingQuestion {
    return Intl.message(
      'How did the day go?',
      name: 'dayRatingQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Select an option below and leave a note.`
  String get selectOptionAndNote {
    return Intl.message(
      'Select an option below and leave a note.',
      name: 'selectOptionAndNote',
      desc: '',
      args: [],
    );
  }

  /// `Review Log`
  String get reviewLog {
    return Intl.message(
      'Review Log',
      name: 'reviewLog',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to upload any photos to this log for your case manager to see? `
  String get uploadLogPhoto {
    return Intl.message(
      'Would you like to upload any photos to this log for your case manager to see? ',
      name: 'uploadLogPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Did child's medication change?`
  String get medicationQuestion {
    return Intl.message(
      'Did child\'s medication change?',
      name: 'medicationQuestion',
      desc: '',
      args: [],
    );
  }

  /// `How are YOU feeling today?`
  String get howDoYouFeel {
    return Intl.message(
      'How are YOU feeling today?',
      name: 'howDoYouFeel',
      desc: '',
      args: [],
    );
  }

  /// `Upload Photos`
  String get uploadPhotos {
    return Intl.message(
      'Upload Photos',
      name: 'uploadPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Please select a child and parent`
  String get selectChild {
    return Intl.message(
      'Please select a child and parent',
      name: 'selectChild',
      desc: '',
      args: [],
    );
  }

  /// `Select the child to enter the log for today.`
  String get selectChildForLog {
    return Intl.message(
      'Select the child to enter the log for today.',
      name: 'selectChildForLog',
      desc: '',
      args: [],
    );
  }

  /// `Please enter notes in the box above`
  String get enterNotesAbove {
    return Intl.message(
      'Please enter notes in the box above',
      name: 'enterNotesAbove',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Additional Notes`
  String get additionalNotes {
    return Intl.message(
      'Additional Notes',
      name: 'additionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `Save Note`
  String get saveNote {
    return Intl.message(
      'Save Note',
      name: 'saveNote',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get enterCurrentPassword {
    return Intl.message(
      'Please enter your current password',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password`
  String get confirmPassword {
    return Intl.message(
      'Please confirm your new password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get enterNewPassword {
    return Intl.message(
      'Please enter a new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password and the new password you'd like to use.`
  String get enterCurrentAndNewPassword {
    return Intl.message(
      'Enter your current password and the new password you\'d like to use.',
      name: 'enterCurrentAndNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordShort {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordShort',
      desc: '',
      args: [],
    );
  }

  /// `Passwords must match`
  String get passwordMustMatch {
    return Intl.message(
      'Passwords must match',
      name: 'passwordMustMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get enterPassword {
    return Intl.message(
      'Please enter a password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get genericError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Set Password`
  String get setPassword {
    return Intl.message(
      'Set Password',
      name: 'setPassword',
      desc: '',
      args: [],
    );
  }

  /// `Set your password for regular use.`
  String get setPasswordRegular {
    return Intl.message(
      'Set your password for regular use.',
      name: 'setPasswordRegular',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Please enter in the confirmation code.`
  String get enterConfirmationCode {
    return Intl.message(
      'Please enter in the confirmation code.',
      name: 'enterConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `The code you entered is incorrect.`
  String get incorrectConfirmationCode {
    return Intl.message(
      'The code you entered is incorrect.',
      name: 'incorrectConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `The code you entered is expired.`
  String get expiredConfirmationCode {
    return Intl.message(
      'The code you entered is expired.',
      name: 'expiredConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `Email Sent`
  String get emailSent {
    return Intl.message(
      'Email Sent',
      name: 'emailSent',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 6 digit verification code that was sent to`
  String get enterVerificationCode {
    return Intl.message(
      'Enter the 6 digit verification code that was sent to',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Get in touch with us through email or get help with our FAQ page`
  String get getInTouch {
    return Intl.message(
      'Get in touch with us through email or get help with our FAQ page',
      name: 'getInTouch',
      desc: '',
      args: [],
    );
  }

  /// `Email Us`
  String get emailUs {
    return Intl.message(
      'Email Us',
      name: 'emailUs',
      desc: '',
      args: [],
    );
  }

  /// `Enter a first name`
  String get enterFirstName {
    return Intl.message(
      'Enter a first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a last name`
  String get enterLastName {
    return Intl.message(
      'Enter a last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Primary Parent`
  String get primaryParent {
    return Intl.message(
      'Primary Parent',
      name: 'primaryParent',
      desc: '',
      args: [],
    );
  }

  /// `Other Information`
  String get otherInformation {
    return Intl.message(
      'Other Information',
      name: 'otherInformation',
      desc: '',
      args: [],
    );
  }

  /// `Zip code`
  String get zipCode {
    return Intl.message(
      'Zip code',
      name: 'zipCode',
      desc: '',
      args: [],
    );
  }

  /// `Foster Family License Number`
  String get licenseNumber {
    return Intl.message(
      'Foster Family License Number',
      name: 'licenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `Primary Language`
  String get primaryLanguage {
    return Intl.message(
      'Primary Language',
      name: 'primaryLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `You are RSVP'd!`
  String get rsvpd {
    return Intl.message(
      'You are RSVP\'d!',
      name: 'rsvpd',
      desc: '',
      args: [],
    );
  }

  /// `Add To Calendar`
  String get addToCalendar {
    return Intl.message(
      'Add To Calendar',
      name: 'addToCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Will you be attending this event?`
  String get willYouAttend {
    return Intl.message(
      'Will you be attending this event?',
      name: 'willYouAttend',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I'm going`
  String get imGoing {
    return Intl.message(
      'Yes, I\'m going',
      name: 'imGoing',
      desc: '',
      args: [],
    );
  }

  /// `No I'm not`
  String get imNotGoing {
    return Intl.message(
      'No I\'m not',
      name: 'imNotGoing',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get uploadImage {
    return Intl.message(
      'Upload Image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Image Name`
  String get imageName {
    return Intl.message(
      'Image Name',
      name: 'imageName',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Foster Details`
  String get fosterDetails {
    return Intl.message(
      'Foster Details',
      name: 'fosterDetails',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalidEmail {
    return Intl.message(
      'Invalid Email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Don't fret! Enter the email associated with your account and we will send you a recovery verification code.`
  String get recoveryCode {
    return Intl.message(
      'Don\'t fret! Enter the email associated with your account and we will send you a recovery verification code.',
      name: 'recoveryCode',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `No notes have been added`
  String get noNotesAdded {
    return Intl.message(
      'No notes have been added',
      name: 'noNotesAdded',
      desc: '',
      args: [],
    );
  }

  /// `Complete Log`
  String get completeLog {
    return Intl.message(
      'Complete Log',
      name: 'completeLog',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email or Password`
  String get invalidEmailOrPass {
    return Intl.message(
      'Invalid Email or Password',
      name: 'invalidEmailOrPass',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again later`
  String get tooManyAttempts {
    return Intl.message(
      'Too many attempts. Please try again later',
      name: 'tooManyAttempts',
      desc: '',
      args: [],
    );
  }

  /// `There was an error loading your children. Please tap below to try loading again.`
  String get errorLoadingChildren2 {
    return Intl.message(
      'There was an error loading your children. Please tap below to try loading again.',
      name: 'errorLoadingChildren2',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Case Manager`
  String get caseManager {
    return Intl.message(
      'Case Manager',
      name: 'caseManager',
      desc: '',
      args: [],
    );
  }

  /// `Total Logs`
  String get totalLogs {
    return Intl.message(
      'Total Logs',
      name: 'totalLogs',
      desc: '',
      args: [],
    );
  }

  /// `Recent Logs`
  String get recentLogs {
    return Intl.message(
      'Recent Logs',
      name: 'recentLogs',
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

  /// `New Event`
  String get newEvent {
    return Intl.message(
      'New Event',
      name: 'newEvent',
      desc: '',
      args: [],
    );
  }

  /// `Daily Log Reminders`
  String get dailyLogReminders {
    return Intl.message(
      'Daily Log Reminders',
      name: 'dailyLogReminders',
      desc: '',
      args: [],
    );
  }

  /// `Month Review Reminders`
  String get monthlyReviewReminders {
    return Intl.message(
      'Month Review Reminders',
      name: 'monthlyReviewReminders',
      desc: '',
      args: [],
    );
  }

  /// `Tips for Engagement`
  String get engagementTips {
    return Intl.message(
      'Tips for Engagement',
      name: 'engagementTips',
      desc: '',
      args: [],
    );
  }

  /// `Updates from CPA`
  String get updatesFromCPA {
    return Intl.message(
      'Updates from CPA',
      name: 'updatesFromCPA',
      desc: '',
      args: [],
    );
  }

  /// `You have no messages at this time. Please tap below to check again.`
  String get noNotifications {
    return Intl.message(
      'You have no messages at this time. Please tap below to check again.',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to FosterShare, fill in the information below in order to get started.`
  String get welcomeToFS {
    return Intl.message(
      'Welcome to FosterShare, fill in the information below in order to get started.',
      name: 'welcomeToFS',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueStr {
    return Intl.message(
      'Continue',
      name: 'continueStr',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `About FosterShare`
  String get aboutFS {
    return Intl.message(
      'About FosterShare',
      name: 'aboutFS',
      desc: '',
      args: [],
    );
  }

  /// `Powered by Miracle Foundation, FosterShare is the digital assistant for Texas Foster Parents. With a streamlined foster care calendar, simplified daily logging, quick connections to nearby wraparound services and helpful articles, blogs and forums when you need them most, FosterShare is your virtual personal assistant - always at the touch of a button.`
  String get fsSummary {
    return Intl.message(
      'Powered by Miracle Foundation, FosterShare is the digital assistant for Texas Foster Parents. With a streamlined foster care calendar, simplified daily logging, quick connections to nearby wraparound services and helpful articles, blogs and forums when you need them most, FosterShare is your virtual personal assistant - always at the touch of a button.',
      name: 'fsSummary',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Great! Please check your email for a confirmation code and create a new password to log in.`
  String get checkConfirmationCode {
    return Intl.message(
      'Great! Please check your email for a confirmation code and create a new password to log in.',
      name: 'checkConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `There are no resources at this time. Please click below to check again.`
  String get noResources {
    return Intl.message(
      'There are no resources at this time. Please click below to check again.',
      name: 'noResources',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem loading resources. Please try again.`
  String get errorLoadingResources {
    return Intl.message(
      'There was a problem loading resources. Please try again.',
      name: 'errorLoadingResources',
      desc: '',
      args: [],
    );
  }

  /// `Missing`
  String get missing {
    return Intl.message(
      'Missing',
      name: 'missing',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incomplete {
    return Intl.message(
      'Incomplete',
      name: 'incomplete',
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

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message(
      'Hi',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `Support Service`
  String get supportService {
    return Intl.message(
      'Support Service',
      name: 'supportService',
      desc: '',
      args: [],
    );
  }

  /// `Support Services`
  String get supportServices {
    return Intl.message(
      'Support Services',
      name: 'supportServices',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
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

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Tap on an item to edit`
  String get tapItemEdit {
    return Intl.message(
      'Tap on an item to edit',
      name: 'tapItemEdit',
      desc: '',
      args: [],
    );
  }

  /// `Great`
  String get great {
    return Intl.message(
      'Great',
      name: 'great',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message(
      'Good',
      name: 'good',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get average {
    return Intl.message(
      'Average',
      name: 'average',
      desc: '',
      args: [],
    );
  }

  /// `So-So`
  String get soso {
    return Intl.message(
      'So-So',
      name: 'soso',
      desc: '',
      args: [],
    );
  }

  /// `Hard Day`
  String get hardDay {
    return Intl.message(
      'Hard Day',
      name: 'hardDay',
      desc: '',
      args: [],
    );
  }

  /// `Aggression`
  String get aggression {
    return Intl.message(
      'Aggression',
      name: 'aggression',
      desc: '',
      args: [],
    );
  }

  /// `Anxiety`
  String get anxiety {
    return Intl.message(
      'Anxiety',
      name: 'anxiety',
      desc: '',
      args: [],
    );
  }

  /// `Bed Wetting`
  String get bedWetting {
    return Intl.message(
      'Bed Wetting',
      name: 'bedWetting',
      desc: '',
      args: [],
    );
  }

  /// `Depression`
  String get depression {
    return Intl.message(
      'Depression',
      name: 'depression',
      desc: '',
      args: [],
    );
  }

  /// `Food Issues`
  String get foodIssues {
    return Intl.message(
      'Food Issues',
      name: 'foodIssues',
      desc: '',
      args: [],
    );
  }

  /// `School Issues`
  String get schoolIssues {
    return Intl.message(
      'School Issues',
      name: 'schoolIssues',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Zip Code.`
  String get enterValidZip {
    return Intl.message(
      'Please enter a valid Zip Code.',
      name: 'enterValidZip',
      desc: '',
      args: [],
    );
  }

  /// `There was an error saving the note. Please try again.`
  String get errorSavingNote {
    return Intl.message(
      'There was an error saving the note. Please try again.',
      name: 'errorSavingNote',
      desc: '',
      args: [],
    );
  }

  /// `Unable to launch website`
  String get unableToLaunchWebsite {
    return Intl.message(
      'Unable to launch website',
      name: 'unableToLaunchWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send email`
  String get unableToSendEmail {
    return Intl.message(
      'Unable to send email',
      name: 'unableToSendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send SMS`
  String get unableToSendSms {
    return Intl.message(
      'Unable to send SMS',
      name: 'unableToSendSms',
      desc: '',
      args: [],
    );
  }

  /// `Unable to make phone call`
  String get unableToMakePhoneCall {
    return Intl.message(
      'Unable to make phone call',
      name: 'unableToMakePhoneCall',
      desc: '',
      args: [],
    );
  }

  /// `Website copied`
  String get websiteCopied {
    return Intl.message(
      'Website copied',
      name: 'websiteCopied',
      desc: '',
      args: [],
    );
  }

  /// `Phone number copied`
  String get phoneNumberCopied {
    return Intl.message(
      'Phone number copied',
      name: 'phoneNumberCopied',
      desc: '',
      args: [],
    );
  }

  /// `Email copied`
  String get emailCopied {
    return Intl.message(
      'Email copied',
      name: 'emailCopied',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset Required`
  String get passwordResetRequired {
    return Intl.message(
      'Password Reset Required',
      name: 'passwordResetRequired',
      desc: '',
      args: [],
    );
  }

  /// `New code sent`
  String get newCodeSent {
    return Intl.message(
      'New code sent',
      name: 'newCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending invitation. Please try again later.`
  String get errorSendingInvite {
    return Intl.message(
      'Error sending invitation. Please try again later.',
      name: 'errorSendingInvite',
      desc: '',
      args: [],
    );
  }

  /// `Your profile was sucessfully updated`
  String get profileUpdated {
    return Intl.message(
      'Your profile was sucessfully updated',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `There was an error updating  your profile. Please try again.`
  String get errorUpdatingProfile {
    return Intl.message(
      'There was an error updating  your profile. Please try again.',
      name: 'errorUpdatingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Your profile was sucessfully changed.`
  String get profileSuccessfullyChanged {
    return Intl.message(
      'Your profile was sucessfully changed.',
      name: 'profileSuccessfullyChanged',
      desc: '',
      args: [],
    );
  }

  /// `There was an error changing your password. Please try again.`
  String get errorChangingPassword {
    return Intl.message(
      'There was an error changing your password. Please try again.',
      name: 'errorChangingPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invite Sent`
  String get inviteSent {
    return Intl.message(
      'Invite Sent',
      name: 'inviteSent',
      desc: '',
      args: [],
    );
  }

  /// `Not Submitted`
  String get notSubmitted {
    return Intl.message(
      'Not Submitted',
      name: 'notSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Not Signed`
  String get notSigned {
    return Intl.message(
      'Not Signed',
      name: 'notSigned',
      desc: '',
      args: [],
    );
  }

  /// `Med Log`
  String get medLog {
    return Intl.message(
      'Med Log',
      name: 'medLog',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get submitted {
    return Intl.message(
      'Submitted',
      name: 'submitted',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Recreation Log`
  String get recreationLog {
    return Intl.message(
      'Recreation Log',
      name: 'recreationLog',
      desc: '',
      args: [],
    );
  }

  /// `Add Recreation Log`
  String get addRecreationLog {
    return Intl.message(
      'Add Recreation Log',
      name: 'addRecreationLog',
      desc: '',
      args: [],
    );
  }

  /// `Daily Indoor And Outdoor Individual Free Time, Community, Family Activities`
  String get recreationActivityQuestion {
    return Intl.message(
      'Daily Indoor And Outdoor Individual Free Time, Community, Family Activities',
      name: 'recreationActivityQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Add Activity Comments`
  String get recreationActivitySubQuestion {
    return Intl.message(
      'Add Activity Comments',
      name: 'recreationActivitySubQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Describe activities in few words`
  String get decribeActivities {
    return Intl.message(
      'Describe activities in few words',
      name: 'decribeActivities',
      desc: '',
      args: [],
    );
  }

  /// `Select Activities`
  String get recreationActivitySelectQuestion {
    return Intl.message(
      'Select Activities',
      name: 'recreationActivitySelectQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Daily Indoor And Outdoor Activity`
  String get dailyIndoorOutdoorActivity {
    return Intl.message(
      'Daily Indoor And Outdoor Activity',
      name: 'dailyIndoorOutdoorActivity',
      desc: '',
      args: [],
    );
  }

  /// `Individual Free Time Activity`
  String get individualFreeTimeActivity {
    return Intl.message(
      'Individual Free Time Activity',
      name: 'individualFreeTimeActivity',
      desc: '',
      args: [],
    );
  }

  /// `Community Activity`
  String get communityActivity {
    return Intl.message(
      'Community Activity',
      name: 'communityActivity',
      desc: '',
      args: [],
    );
  }

  /// `Family Activity`
  String get familyActivity {
    return Intl.message(
      'Family Activity',
      name: 'familyActivity',
      desc: '',
      args: [],
    );
  }

  /// `Team Work`
  String get teamWork {
    return Intl.message(
      'Team Work',
      name: 'teamWork',
      desc: '',
      args: [],
    );
  }

  /// `Fitness`
  String get fitness {
    return Intl.message(
      'Fitness',
      name: 'fitness',
      desc: '',
      args: [],
    );
  }

  /// `Coordination`
  String get coordination {
    return Intl.message(
      'Coordination',
      name: 'coordination',
      desc: '',
      args: [],
    );
  }

  /// `Communication Skill`
  String get communicationSkill {
    return Intl.message(
      'Communication Skill',
      name: 'communicationSkill',
      desc: '',
      args: [],
    );
  }

  /// `Social Skill`
  String get socialSkill {
    return Intl.message(
      'Social Skill',
      name: 'socialSkill',
      desc: '',
      args: [],
    );
  }

  /// `Self Esteem`
  String get selfEsteem {
    return Intl.message(
      'Self Esteem',
      name: 'selfEsteem',
      desc: '',
      args: [],
    );
  }

  /// `Relational`
  String get relational {
    return Intl.message(
      'Relational',
      name: 'relational',
      desc: '',
      args: [],
    );
  }

  /// `Sharing`
  String get sharing {
    return Intl.message(
      'Sharing',
      name: 'sharing',
      desc: '',
      args: [],
    );
  }

  /// `Problem Solving`
  String get problemSolving {
    return Intl.message(
      'Problem Solving',
      name: 'problemSolving',
      desc: '',
      args: [],
    );
  }

  /// `Hand/Eye Coordination`
  String get handEyeCordination {
    return Intl.message(
      'Hand/Eye Coordination',
      name: 'handEyeCordination',
      desc: '',
      args: [],
    );
  }

  /// `Impulse Control`
  String get impluseControl {
    return Intl.message(
      'Impulse Control',
      name: 'impluseControl',
      desc: '',
      args: [],
    );
  }

  /// `Creative Expression`
  String get creativeExpression {
    return Intl.message(
      'Creative Expression',
      name: 'creativeExpression',
      desc: '',
      args: [],
    );
  }

  /// `Stress Management`
  String get stressManagement {
    return Intl.message(
      'Stress Management',
      name: 'stressManagement',
      desc: '',
      args: [],
    );
  }

  /// `Healthy Autonomy`
  String get healthyAnotonomy {
    return Intl.message(
      'Healthy Autonomy',
      name: 'healthyAnotonomy',
      desc: '',
      args: [],
    );
  }

  /// `Personal Growth`
  String get personalGrowth {
    return Intl.message(
      'Personal Growth',
      name: 'personalGrowth',
      desc: '',
      args: [],
    );
  }

  /// `Self Evaluaton`
  String get selfEvaluaton {
    return Intl.message(
      'Self Evaluaton',
      name: 'selfEvaluaton',
      desc: '',
      args: [],
    );
  }

  /// `Social Skills Practice`
  String get socialSkillsPractice {
    return Intl.message(
      'Social Skills Practice',
      name: 'socialSkillsPractice',
      desc: '',
      args: [],
    );
  }

  /// `Connect With Culture`
  String get connectWithCulture {
    return Intl.message(
      'Connect With Culture',
      name: 'connectWithCulture',
      desc: '',
      args: [],
    );
  }

  /// `Independent Living`
  String get independentLiving {
    return Intl.message(
      'Independent Living',
      name: 'independentLiving',
      desc: '',
      args: [],
    );
  }

  /// `Social Contribution`
  String get socialContribution {
    return Intl.message(
      'Social Contribution',
      name: 'socialContribution',
      desc: '',
      args: [],
    );
  }

  /// `Communication Skills`
  String get communicationSkills {
    return Intl.message(
      'Communication Skills',
      name: 'communicationSkills',
      desc: '',
      args: [],
    );
  }

  /// `Family Cohesion`
  String get familyCohesion {
    return Intl.message(
      'Family Cohesion',
      name: 'familyCohesion',
      desc: '',
      args: [],
    );
  }

  /// `Relational Skills`
  String get relationalSkills {
    return Intl.message(
      'Relational Skills',
      name: 'relationalSkills',
      desc: '',
      args: [],
    );
  }

  /// `Sense Of Belonging`
  String get senseOfBelonging {
    return Intl.message(
      'Sense Of Belonging',
      name: 'senseOfBelonging',
      desc: '',
      args: [],
    );
  }

  /// `Role Model Life Skills`
  String get roleModelLifeSkills {
    return Intl.message(
      'Role Model Life Skills',
      name: 'roleModelLifeSkills',
      desc: '',
      args: [],
    );
  }

  /// `Social Integration`
  String get socialIntegration {
    return Intl.message(
      'Social Integration',
      name: 'socialIntegration',
      desc: '',
      args: [],
    );
  }

  /// `Nick Name`
  String get nickName {
    return Intl.message(
      'Nick Name',
      name: 'nickName',
      desc: '',
      args: [],
    );
  }

  /// `Add Behavior Log`
  String get addBehaviorLog {
    return Intl.message(
      'Add Behavior Log',
      name: 'addBehaviorLog',
      desc: '',
      args: [],
    );
  }

  /// `Behavior Log`
  String get behaviorLog {
    return Intl.message(
      'Behavior Log',
      name: 'behaviorLog',
      desc: '',
      args: [],
    );
  }

  /// `Rec Log`
  String get recLog {
    return Intl.message(
      'Rec Log',
      name: 'recLog',
      desc: '',
      args: [],
    );
  }

  /// `User Disabled`
  String get userDisabled {
    return Intl.message(
      'User Disabled',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Children Nick Name`
  String get childrenNickName {
    return Intl.message(
      'Children Nick Name',
      name: 'childrenNickName',
      desc: '',
      args: [],
    );
  }

  /// `Add Medicine Log`
  String get addMedLog {
    return Intl.message(
      'Add Medicine Log',
      name: 'addMedLog',
      desc: '',
      args: [],
    );
  }

  /// `Submit monthly med log`
  String get submitMontlyMedLog {
    return Intl.message(
      'Submit monthly med log',
      name: 'submitMontlyMedLog',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow `
  String get tomorrow {
    return Intl.message(
      'Tomorrow ',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get upcoming {
    return Intl.message(
      'Upcoming',
      name: 'upcoming',
      desc: '',
      args: [],
    );
  }

  /// `Signing InProgress`
  String get signingInprogress {
    return Intl.message(
      'Signing InProgress',
      name: 'signingInprogress',
      desc: '',
      args: [],
    );
  }

  /// `No Medication`
  String get noMedication {
    return Intl.message(
      'No Medication',
      name: 'noMedication',
      desc: '',
      args: [],
    );
  }

  /// `Missed`
  String get missed {
    return Intl.message(
      'Missed',
      name: 'missed',
      desc: '',
      args: [],
    );
  }

  /// `Administered`
  String get administered {
    return Intl.message(
      'Administered',
      name: 'administered',
      desc: '',
      args: [],
    );
  }

  /// `Logged By`
  String get loggedBy {
    return Intl.message(
      'Logged By',
      name: 'loggedBy',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get purpose {
    return Intl.message(
      'Purpose',
      name: 'purpose',
      desc: '',
      args: [],
    );
  }

  /// `Not Administered`
  String get notAdministered {
    return Intl.message(
      'Not Administered',
      name: 'notAdministered',
      desc: '',
      args: [],
    );
  }

  /// `Administered at`
  String get administeredAt {
    return Intl.message(
      'Administered at',
      name: 'administeredAt',
      desc: '',
      args: [],
    );
  }

  /// `Add New Medication`
  String get addNewMedication {
    return Intl.message(
      'Add New Medication',
      name: 'addNewMedication',
      desc: '',
      args: [],
    );
  }

  /// `Select all medications administered`
  String get selectAllMedicationAdministred {
    return Intl.message(
      'Select all medications administered',
      name: 'selectAllMedicationAdministred',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Name of medication`
  String get nameOfMedication {
    return Intl.message(
      'Name of medication',
      name: 'nameOfMedication',
      desc: '',
      args: [],
    );
  }

  /// `Dosage in milligrams`
  String get dosageInMilligram {
    return Intl.message(
      'Dosage in milligrams',
      name: 'dosageInMilligram',
      desc: '',
      args: [],
    );
  }

  /// `Strength`
  String get strength {
    return Intl.message(
      'Strength',
      name: 'strength',
      desc: '',
      args: [],
    );
  }

  /// `Prescribing doctor`
  String get prescribingDoctor {
    return Intl.message(
      'Prescribing doctor',
      name: 'prescribingDoctor',
      desc: '',
      args: [],
    );
  }

  /// `If applicable`
  String get ifApplicable {
    return Intl.message(
      'If applicable',
      name: 'ifApplicable',
      desc: '',
      args: [],
    );
  }

  /// `Medication Notes`
  String get medicationNotes {
    return Intl.message(
      'Medication Notes',
      name: 'medicationNotes',
      desc: '',
      args: [],
    );
  }

  /// `Initial and Submit`
  String get initialAndSubmit {
    return Intl.message(
      'Initial and Submit',
      name: 'initialAndSubmit',
      desc: '',
      args: [],
    );
  }

  /// `I certify that the above information is true and correct. By checking the following box, I affimatively agree that I am providing a legally binding electronic signature.`
  String get agreeTheMedication {
    return Intl.message(
      'I certify that the above information is true and correct. By checking the following box, I affimatively agree that I am providing a legally binding electronic signature.',
      name: 'agreeTheMedication',
      desc: '',
      args: [],
    );
  }

  /// `Dosage`
  String get dosage {
    return Intl.message(
      'Dosage',
      name: 'dosage',
      desc: '',
      args: [],
    );
  }

  /// `Logged Time`
  String get loggedTime {
    return Intl.message(
      'Logged Time',
      name: 'loggedTime',
      desc: '',
      args: [],
    );
  }

  /// `Administered by`
  String get administeredBy {
    return Intl.message(
      'Administered by',
      name: 'administeredBy',
      desc: '',
      args: [],
    );
  }

  /// `Administered to`
  String get administeredTo {
    return Intl.message(
      'Administered to',
      name: 'administeredTo',
      desc: '',
      args: [],
    );
  }

  /// `Reason not administed`
  String get reasonNotAdministered {
    return Intl.message(
      'Reason not administed',
      name: 'reasonNotAdministered',
      desc: '',
      args: [],
    );
  }

  /// `No medications were administered `
  String get noMedineAdminitered {
    return Intl.message(
      'No medications were administered ',
      name: 'noMedineAdminitered',
      desc: '',
      args: [],
    );
  }

  /// `When was the following medicine administered?`
  String get whenFollowingMedAdministered {
    return Intl.message(
      'When was the following medicine administered?',
      name: 'whenFollowingMedAdministered',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Earlier`
  String get earlier {
    return Intl.message(
      'Earlier',
      name: 'earlier',
      desc: '',
      args: [],
    );
  }

  /// `Report 'None Administered'`
  String get reportNoneAdministered {
    return Intl.message(
      'Report \'None Administered\'',
      name: 'reportNoneAdministered',
      desc: '',
      args: [],
    );
  }

  /// `Why wasn't the following administered?`
  String get whyWasntAdministered {
    return Intl.message(
      'Why wasn\'t the following administered?',
      name: 'whyWasntAdministered',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message(
      'Required',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Description of failure`
  String get descriptionOfFailure {
    return Intl.message(
      'Description of failure',
      name: 'descriptionOfFailure',
      desc: '',
      args: [],
    );
  }

  /// `Were any medications missed?`
  String get wereAnyMedMissed {
    return Intl.message(
      'Were any medications missed?',
      name: 'wereAnyMedMissed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to complete all entries for the month before submitting. Once submitted, it cannot be undone.`
  String get makeSureAllEntriesSubmitted {
    return Intl.message(
      'Make sure to complete all entries for the month before submitting. Once submitted, it cannot be undone.',
      name: 'makeSureAllEntriesSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Sign`
  String get proceedToSign {
    return Intl.message(
      'Proceed to Sign',
      name: 'proceedToSign',
      desc: '',
      args: [],
    );
  }

  /// `Past Due`
  String get pastDue {
    return Intl.message(
      'Past Due',
      name: 'pastDue',
      desc: '',
      args: [],
    );
  }

  /// `You successfully submitted the`
  String get medlogSubmitSuccess {
    return Intl.message(
      'You successfully submitted the',
      name: 'medlogSubmitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Field should not be empty`
  String get fieldNotBeEmpty {
    return Intl.message(
      'Field should not be empty',
      name: 'fieldNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Must select atleast one`
  String get selectAlteastOne {
    return Intl.message(
      'Must select atleast one',
      name: 'selectAlteastOne',
      desc: '',
      args: [],
    );
  }

  /// `Please choose Checkbox to proceed`
  String get checkTheBox {
    return Intl.message(
      'Please choose Checkbox to proceed',
      name: 'checkTheBox',
      desc: '',
      args: [],
    );
  }

  /// `Child Refused`
  String get childRefused {
    return Intl.message(
      'Child Refused',
      name: 'childRefused',
      desc: '',
      args: [],
    );
  }

  /// `Missed Window`
  String get missedWindow {
    return Intl.message(
      'Missed Window',
      name: 'missedWindow',
      desc: '',
      args: [],
    );
  }

  /// `Unable to create`
  String get unableToCreate {
    return Intl.message(
      'Unable to create',
      name: 'unableToCreate',
      desc: '',
      args: [],
    );
  }

  /// `Unable to submit`
  String get unableToSubmit {
    return Intl.message(
      'Unable to submit',
      name: 'unableToSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Add More Logs`
  String get addMoreLogs {
    return Intl.message(
      'Add More Logs',
      name: 'addMoreLogs',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem loading avtivities. Please try again.`
  String get errorLoadingActivities {
    return Intl.message(
      'There was a problem loading avtivities. Please try again.',
      name: 'errorLoadingActivities',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Submitted`
  String get submitSuccess {
    return Intl.message(
      'Successfully Submitted',
      name: 'submitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Describe why the medicine couldn't be administered`
  String get describeWhyNotAdminitered {
    return Intl.message(
      'Describe why the medicine couldn\'t be administered',
      name: 'describeWhyNotAdminitered',
      desc: '',
      args: [],
    );
  }

  /// `Wait for Sign..`
  String get waitForSign {
    return Intl.message(
      'Wait for Sign..',
      name: 'waitForSign',
      desc: '',
      args: [],
    );
  }

  /// `Medication Log`
  String get medicationLog {
    return Intl.message(
      'Medication Log',
      name: 'medicationLog',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Med Log`
  String get monthlyMedLog {
    return Intl.message(
      'Monthly Med Log',
      name: 'monthlyMedLog',
      desc: '',
      args: [],
    );
  }

  /// `Review monthly med log and sign`
  String get reviewMonthlyMedLogSign {
    return Intl.message(
      'Review monthly med log and sign',
      name: 'reviewMonthlyMedLogSign',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Med Log Details`
  String get monthlyMedLogDetails {
    return Intl.message(
      'Monthly Med Log Details',
      name: 'monthlyMedLogDetails',
      desc: '',
      args: [],
    );
  }

  /// `Medication of`
  String get medicationOf {
    return Intl.message(
      'Medication of',
      name: 'medicationOf',
      desc: '',
      args: [],
    );
  }

  /// `Administered Time`
  String get administeredTime {
    return Intl.message(
      'Administered Time',
      name: 'administeredTime',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}