import 'package:animations/animations.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/app/guards/registration_guard.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/ui/views/bottom_nav/bottom_nav_view.dart';
import 'package:fostershare/ui/views/change_password/change_password_view.dart';
import 'package:fostershare/ui/views/confirm_sign_in/confirm_sign_in_view.dart';
import 'package:fostershare/ui/views/confirmation_code/confirmation_code_view.dart';
import 'package:fostershare/ui/views/contact_us/contact_us_view.dart';
import 'package:fostershare/ui/views/edit_log_view/edit_log_view.dart';
import 'package:fostershare/ui/views/edit_profile/edit_profile_view.dart';
import 'package:fostershare/ui/views/event_detail/event_detail_view.dart';
import 'package:fostershare/ui/views/family_image_preview/family_image_preview_view.dart';
import 'package:fostershare/ui/views/family_registration/family_registration_view.dart';
import 'package:fostershare/ui/views/forgot_password/forgot_password_view.dart';
import 'package:fostershare/ui/views/local_resources/local_resources_view.dart';
import 'package:fostershare/ui/views/log_summary/log_summary_view.dart';
import 'package:fostershare/ui/views/login/login_view.dart';
import 'package:fostershare/ui/views/med_log/med_logs_list_view.dart';
import 'package:fostershare/ui/views/med_log_details/med_log_details_view.dart';
import 'package:fostershare/ui/views/med_log_details/med_log_extended_details_view.dart';
import 'package:fostershare/ui/views/med_log_details/signing_view.dart';
import 'package:fostershare/ui/views/my_children/my_children_view.dart';
import 'package:fostershare/ui/views/notification_settings/notification_settings_view.dart';
import 'package:fostershare/ui/views/onboarding/onboarding_view.dart';
import 'package:fostershare/ui/views/parents_registration/parents_registration_view.dart';
import 'package:fostershare/ui/views/reset_password/reset_password_view.dart';
import 'package:fostershare/ui/views/resource_category/resource_category_view.dart';
import 'package:fostershare/ui/views/resource_detail/resource_detail_view.dart';
import 'package:fostershare/ui/views/start_up/start_up_view.dart';
import 'package:fostershare/ui/views/support_service_view/support_service_view.dart';
import 'package:fostershare/ui/views/support_services_view/support_services_view.dart';
import 'package:fostershare/ui/views/upload_image/upload_image_view.dart';
import 'package:fostershare/ui/views/welcome/welcome_view.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_view.dart';
import 'package:fostershare/ui/views/recreation_log_summary/recreation_log_summary_view.dart';

Widget fadeTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  // you get an animation object and a widget
  // make your own transition
  return FadeTransition(opacity: animation, child: child);
}

// TODO
Widget fadeThroughTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  // you get an animation object and a widget
  // make your own transition
  return FadeThroughTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
}

@MaterialAutoRouter(
  routes: <AutoRoute>[
    CustomRoute(
      page: BottomNavView,
      transitionsBuilder: fadeThroughTransition,
      durationInMilliseconds: 3000,
      guards: [RegistrationGuard], // TODO revisit
    ),
    MaterialRoute(page: ChangePasswordView),
    MaterialRoute(page: ConfirmSignInView),
    MaterialRoute(page: ConfirmationCodeView),
    MaterialRoute(page: ContactUsView),
    MaterialRoute(page: EditProfileView),
    MaterialRoute(page: EventDetailView),
    MaterialRoute(page: FamilyRegistrationView),
    MaterialRoute(page: ForgotPasswordView),
    MaterialRoute(page: LocalResourcesView),
    MaterialRoute(page: LoginView),
    MaterialRoute<ChildLog>(page: LogSummaryView),
    MaterialRoute(page: MyChildrenView),
    MaterialRoute(page: NotificationSettingsView), // TODO cupertino?
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: ParentsRegistrationView),
    MaterialRoute(page: ResetPasswordView),
    MaterialRoute(page: ResourceCategoryView),
    MaterialRoute(page: ResourceDetailView),
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: FamilyImagePreviewView),
    MaterialRoute(page: UploadImageView),
    MaterialRoute(page: SupportServiceView),
    MaterialRoute(page: SupportServicesView),
    MaterialRoute(page: MedLogDetailsView),
    MaterialRoute(page: SigningView),
    MaterialRoute(page: MedLogExtendedDetailsView),
    MaterialRoute(page: MedLogView),
    MaterialRoute(page: RecreationLogView),
    MaterialRoute(page: RecreationLogSummaryView),
    CustomRoute(
      page: WelcomeView,
      transitionsBuilder: fadeTransition,
      durationInMilliseconds: 3000,
    ),
  ],
)
class $AppRouter {}
