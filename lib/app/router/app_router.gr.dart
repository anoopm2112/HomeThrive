// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/models/data/child/child.dart';
import '../../core/models/data/child_log/child_log.dart';
import '../../core/models/data/event/event.dart';
import '../../core/models/data/family/family.dart';
import '../../core/models/data/resource/resource.dart';
import '../../ui/views/bottom_nav/bottom_nav_view.dart';
import '../../ui/views/change_password/change_password_view.dart';
import '../../ui/views/confirm_sign_in/confirm_sign_in_view.dart';
import '../../ui/views/confirmation_code/confirmation_code_view.dart';
import '../../ui/views/contact_us/contact_us_view.dart';
import '../../ui/views/edit_profile/edit_profile_view.dart';
import '../../ui/views/event_detail/event_detail_view.dart';
import '../../ui/views/family_image_preview/family_image_preview_view.dart';
import '../../ui/views/family_registration/family_registration_view.dart';
import '../../ui/views/forgot_password/forgot_password_view.dart';
import '../../ui/views/local_resources/local_resources_view.dart';
import '../../ui/views/log_summary/log_summary_view.dart';
import '../../ui/views/login/login_view.dart';
import '../../ui/views/med_log/med_logs_list_view.dart';
import '../../ui/views/med_log_details/med_log_details_view.dart';
import '../../ui/views/med_log_details/med_log_extended_details_view.dart';
import '../../ui/views/med_log_details/signing_view.dart';
import '../../ui/views/my_children/my_children_view.dart';
import '../../ui/views/notification_settings/notification_settings_view.dart';
import '../../ui/views/onboarding/onboarding_view.dart';
import '../../ui/views/parents_registration/parents_registration_view.dart';
import '../../ui/views/recreation_log/recreation_log_view.dart';
import '../../ui/views/recreation_log_summary/recreation_log_summary_view.dart';
import '../../ui/views/reset_password/reset_password_view.dart';
import '../../ui/views/resource_category/resource_category_view.dart';
import '../../ui/views/resource_detail/resource_detail_view.dart';
import '../../ui/views/start_up/start_up_view.dart';
import '../../ui/views/support_service_view/support_service_view.dart';
import '../../ui/views/support_services_view/support_services_view.dart';
import '../../ui/views/upload_image/upload_image_view.dart';
import '../../ui/views/welcome/welcome_view.dart';
import '../../ui/widgets/cards/child_log_card.dart';
import '../guards/registration_guard.dart';
import 'app_router.dart';

class Routes {
  static const String bottomNavView = '/bottom-nav-view';
  static const String changePasswordView = '/change-password-view';
  static const String confirmSignInView = '/confirm-sign-in-view';
  static const String confirmationCodeView = '/confirmation-code-view';
  static const String contactUsView = '/contact-us-view';
  static const String editProfileView = '/edit-profile-view';
  static const String eventDetailView = '/event-detail-view';
  static const String familyRegistrationView = '/family-registration-view';
  static const String forgotPasswordView = '/forgot-password-view';
  static const String localResourcesView = '/local-resources-view';
  static const String loginView = '/login-view';
  static const String logSummaryView = '/log-summary-view';
  static const String myChildrenView = '/my-children-view';
  static const String notificationSettingsView = '/notification-settings-view';
  static const String onboardingView = '/onboarding-view';
  static const String parentsRegistrationView = '/parents-registration-view';
  static const String resetPasswordView = '/reset-password-view';
  static const String resourceCategoryView = '/resource-category-view';
  static const String resourceDetailView = '/resource-detail-view';
  static const String startUpView = '/';
  static const String familyImagePreviewView = '/family-image-preview-view';
  static const String uploadImageView = '/upload-image-view';
  static const String supportServiceView = '/support-service-view';
  static const String supportServicesView = '/support-services-view';
  static const String medLogDetailsView = '/med-log-details-view';
  static const String signingView = '/signing-view';
  static const String medLogExtendedDetailsView =
      '/med-log-extended-details-view';
  static const String medLogView = '/med-log-view';
  static const String recreationLogView = '/recreation-log-view';
  static const String recreationLogSummaryView = '/recreation-log-summary-view';
  static const String welcomeView = '/welcome-view';
  static const all = <String>{
    bottomNavView,
    changePasswordView,
    confirmSignInView,
    confirmationCodeView,
    contactUsView,
    editProfileView,
    eventDetailView,
    familyRegistrationView,
    forgotPasswordView,
    localResourcesView,
    loginView,
    logSummaryView,
    myChildrenView,
    notificationSettingsView,
    onboardingView,
    parentsRegistrationView,
    resetPasswordView,
    resourceCategoryView,
    resourceDetailView,
    startUpView,
    familyImagePreviewView,
    uploadImageView,
    supportServiceView,
    supportServicesView,
    medLogDetailsView,
    signingView,
    medLogExtendedDetailsView,
    medLogView,
    recreationLogView,
    recreationLogSummaryView,
    welcomeView,
  };
}

class AppRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.bottomNavView,
        page: BottomNavView, guards: [RegistrationGuard]),
    RouteDef(Routes.changePasswordView, page: ChangePasswordView),
    RouteDef(Routes.confirmSignInView, page: ConfirmSignInView),
    RouteDef(Routes.confirmationCodeView, page: ConfirmationCodeView),
    RouteDef(Routes.contactUsView, page: ContactUsView),
    RouteDef(Routes.editProfileView, page: EditProfileView),
    RouteDef(Routes.eventDetailView, page: EventDetailView),
    RouteDef(Routes.familyRegistrationView, page: FamilyRegistrationView),
    RouteDef(Routes.forgotPasswordView, page: ForgotPasswordView),
    RouteDef(Routes.localResourcesView, page: LocalResourcesView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.logSummaryView, page: LogSummaryView),
    RouteDef(Routes.myChildrenView, page: MyChildrenView),
    RouteDef(Routes.notificationSettingsView, page: NotificationSettingsView),
    RouteDef(Routes.onboardingView, page: OnboardingView),
    RouteDef(Routes.parentsRegistrationView, page: ParentsRegistrationView),
    RouteDef(Routes.resetPasswordView, page: ResetPasswordView),
    RouteDef(Routes.resourceCategoryView, page: ResourceCategoryView),
    RouteDef(Routes.resourceDetailView, page: ResourceDetailView),
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.familyImagePreviewView, page: FamilyImagePreviewView),
    RouteDef(Routes.uploadImageView, page: UploadImageView),
    RouteDef(Routes.supportServiceView, page: SupportServiceView),
    RouteDef(Routes.supportServicesView, page: SupportServicesView),
    RouteDef(Routes.medLogDetailsView, page: MedLogDetailsView),
    RouteDef(Routes.signingView, page: SigningView),
    RouteDef(Routes.medLogExtendedDetailsView, page: MedLogExtendedDetailsView),
    RouteDef(Routes.medLogView, page: MedLogView),
    RouteDef(Routes.recreationLogView, page: RecreationLogView),
    RouteDef(Routes.recreationLogSummaryView, page: RecreationLogSummaryView),
    RouteDef(Routes.welcomeView, page: WelcomeView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    BottomNavView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BottomNavView(),
        settings: data,
        transitionsBuilder: fadeThroughTransition,
        transitionDuration: const Duration(milliseconds: 3000),
      );
    },
    ChangePasswordView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChangePasswordView(),
        settings: data,
      );
    },
    ConfirmSignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmSignInView(),
        settings: data,
      );
    },
    ConfirmationCodeView: (data) {
      final args = data.getArgs<ConfirmationCodeViewArguments>(
        orElse: () => ConfirmationCodeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmationCodeView(
          key: args.key,
          email: args.email,
        ),
        settings: data,
      );
    },
    ContactUsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ContactUsView(),
        settings: data,
      );
    },
    EditProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditProfileView(),
        settings: data,
      );
    },
    EventDetailView: (data) {
      final args = data.getArgs<EventDetailViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EventDetailView(
          key: args.key,
          id: args.id,
          title: args.title,
          eventDetails: args.eventDetails,
        ),
        settings: data,
      );
    },
    FamilyRegistrationView: (data) {
      final args = data.getArgs<FamilyRegistrationViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FamilyRegistrationView(
          key: args.key,
          family: args.family,
        ),
        settings: data,
      );
    },
    ForgotPasswordView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgotPasswordView(),
        settings: data,
      );
    },
    LocalResourcesView: (data) {
      final args = data.getArgs<LocalResourcesViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LocalResourcesView(
          key: args.key,
          resources: args.resources,
        ),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    LogSummaryView: (data) {
      final args = data.getArgs<LogSummaryViewArguments>(nullOk: false);
      return MaterialPageRoute<ChildLog>(
        builder: (context) => LogSummaryView(
          key: args.key,
          id: args.id,
          childLog: args.childLog,
          date: args.date,
          child: args.child,
          status: args.status,
        ),
        settings: data,
      );
    },
    MyChildrenView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MyChildrenView(),
        settings: data,
      );
    },
    NotificationSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotificationSettingsView(),
        settings: data,
      );
    },
    OnboardingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OnboardingView(),
        settings: data,
      );
    },
    ParentsRegistrationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ParentsRegistrationView(),
        settings: data,
      );
    },
    ResetPasswordView: (data) {
      final args = data.getArgs<ResetPasswordViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ResetPasswordView(
          key: args.key,
          email: args.email,
          confirmationCode: args.confirmationCode,
        ),
        settings: data,
      );
    },
    ResourceCategoryView: (data) {
      final args = data.getArgs<ResourceCategoryViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ResourceCategoryView(
          key: args.key,
          id: args.id,
        ),
        settings: data,
      );
    },
    ResourceDetailView: (data) {
      final args = data.getArgs<ResourceDetailViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ResourceDetailView(
          key: args.key,
          resource: args.resource,
        ),
        settings: data,
      );
    },
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(),
        settings: data,
      );
    },
    FamilyImagePreviewView: (data) {
      final args = data.getArgs<FamilyImagePreviewViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => FamilyImagePreviewView(args.imagePath),
        settings: data,
      );
    },
    UploadImageView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => UploadImageView(),
        settings: data,
      );
    },
    SupportServiceView: (data) {
      final args = data.getArgs<SupportServiceViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SupportServiceView(args.supportServiceId),
        settings: data,
      );
    },
    SupportServicesView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SupportServicesView(),
        settings: data,
      );
    },
    MedLogDetailsView: (data) {
      final args = data.getArgs<MedLogDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MedLogDetailsView(args.medLogId),
        settings: data,
      );
    },
    SigningView: (data) {
      final args = data.getArgs<SigningViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SigningView(
          args.signingUrl,
          args.finalUrl,
          args.medLogId,
        ),
        settings: data,
      );
    },
    MedLogExtendedDetailsView: (data) {
      final args =
          data.getArgs<MedLogExtendedDetailsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MedLogExtendedDetailsView(args.medLogId),
        settings: data,
      );
    },
    MedLogView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MedLogView(),
        settings: data,
      );
    },
    RecreationLogView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RecreationLogView(),
        settings: data,
      );
    },
    RecreationLogSummaryView: (data) {
      final args =
          data.getArgs<RecreationLogSummaryViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => RecreationLogSummaryView(args.recLogId),
        settings: data,
      );
    },
    WelcomeView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => WelcomeView(),
        settings: data,
        transitionsBuilder: fadeTransition,
        transitionDuration: const Duration(milliseconds: 3000),
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ConfirmationCodeView arguments holder class
class ConfirmationCodeViewArguments {
  final Key key;
  final String email;
  ConfirmationCodeViewArguments({this.key, this.email});
}

/// EventDetailView arguments holder class
class EventDetailViewArguments {
  final Key key;
  final String id;
  final String title;
  final Event eventDetails;
  EventDetailViewArguments(
      {this.key,
      @required this.id,
      @required this.title,
      @required this.eventDetails});
}

/// FamilyRegistrationView arguments holder class
class FamilyRegistrationViewArguments {
  final Key key;
  final Family family;
  FamilyRegistrationViewArguments({this.key, @required this.family});
}

/// LocalResourcesView arguments holder class
class LocalResourcesViewArguments {
  final Key key;
  final List<Resource> resources;
  LocalResourcesViewArguments({this.key, @required this.resources});
}

/// LogSummaryView arguments holder class
class LogSummaryViewArguments {
  final Key key;
  final String id;
  final ChildLog childLog;
  final DateTime date;
  final Child child;
  final ChildLogStatus status;
  LogSummaryViewArguments(
      {this.key,
      this.id,
      this.childLog,
      @required this.date,
      @required this.child,
      this.status = ChildLogStatus.submitted});
}

/// ResetPasswordView arguments holder class
class ResetPasswordViewArguments {
  final Key key;
  final String email;
  final String confirmationCode;
  ResetPasswordViewArguments(
      {this.key, @required this.email, @required this.confirmationCode});
}

/// ResourceCategoryView arguments holder class
class ResourceCategoryViewArguments {
  final Key key;
  final String id;
  ResourceCategoryViewArguments({this.key, @required this.id});
}

/// ResourceDetailView arguments holder class
class ResourceDetailViewArguments {
  final Key key;
  final Resource resource;
  ResourceDetailViewArguments({this.key, @required this.resource});
}

/// FamilyImagePreviewView arguments holder class
class FamilyImagePreviewViewArguments {
  final String imagePath;
  FamilyImagePreviewViewArguments({@required this.imagePath});
}

/// SupportServiceView arguments holder class
class SupportServiceViewArguments {
  final String supportServiceId;
  SupportServiceViewArguments({@required this.supportServiceId});
}

/// MedLogDetailsView arguments holder class
class MedLogDetailsViewArguments {
  final dynamic medLogId;
  MedLogDetailsViewArguments({@required this.medLogId});
}

/// SigningView arguments holder class
class SigningViewArguments {
  final String signingUrl;
  final String finalUrl;
  final String medLogId;
  SigningViewArguments(
      {@required this.signingUrl,
      @required this.finalUrl,
      @required this.medLogId});
}

/// MedLogExtendedDetailsView arguments holder class
class MedLogExtendedDetailsViewArguments {
  final dynamic medLogId;
  MedLogExtendedDetailsViewArguments({@required this.medLogId});
}

/// RecreationLogSummaryView arguments holder class
class RecreationLogSummaryViewArguments {
  final String recLogId;
  RecreationLogSummaryViewArguments({@required this.recLogId});
}
