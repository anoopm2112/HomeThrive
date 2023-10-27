import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/type/current_user.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/app_service.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

class AuthProfileViewModel extends ReactiveViewModel {
  final _analyticsService = locator<AnalyticsService>();
  final _appService = locator<AppService>();
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authService];

  CurrentUser get _currentUser => _authService.currentUser;

  String get fullName => _currentUser?.fullName;
  bool get showFullName => this.fullName != null;

  String get email => _currentUser?.email;
  bool get showEmail => this.email != null;

  String get versionNumber => _appService.packageInfo.version;

  void onEditProfile() {
    _analyticsService.logProfileViewAction(action: "edit_profile_click");

    _navigationService.navigateTo(Routes.editProfileView);
  }

  void onChangePassword() {
    _analyticsService.logProfileViewAction(action: "change_password_click");

    _navigationService.navigateTo(Routes.changePasswordView);
  }

  void onMyChildren() {
    _analyticsService.logProfileViewAction(action: "my_children_click");

    _navigationService.navigateTo(Routes.myChildrenView);
  }

  void onContactUs() {
    _analyticsService.logProfileViewAction(action: "contact_us_click");

    _navigationService.navigateTo(Routes.contactUsView);
  }

  void onShareApp() {
    _analyticsService.logProfileViewAction(action: "share_app_click");

    Share.share('https://links.fostershare.org/app-store');
  }

  Future<void> onSignOut() async {
    _analyticsService.logProfileViewAction(action: "sign_out_click");

    await _authService.signOut();

    _analyticsService.logSignOut();
  }

  Future<void> onUploadImage() async {
    _analyticsService.logProfileViewAction(action: "upload_image_click");

    _navigationService.navigateTo(Routes.uploadImageView);
  }

  Future<void> onSupportService() async {
    _analyticsService.logProfileViewAction(action: "support_service_click");

    _navigationService.navigateTo(Routes.supportServicesView);
  }

  Future<void> onMedLog() async {
    _analyticsService.logProfileViewAction(action: "med_log_click");

    _navigationService.navigateTo(Routes.medLogView);
  }

  Future<void> onRecreationLog() async {
    _analyticsService.logProfileViewAction(action: "recreation_log_click");

    _navigationService.navigateTo(Routes.recreationLogView);
  }
}
