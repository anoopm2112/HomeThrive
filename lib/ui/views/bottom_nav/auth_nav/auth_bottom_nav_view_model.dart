import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/auth_bottom_nav_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/push_notifications_service.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

// enum AuthBottomNavTab {
//   home,
//   resources,
//   empty,
//   activity,
//   profile,
// }

class AuthBottomNavViewModel extends ReactiveViewModel {
  final _authBottomNavService = locator<AuthBottomNavService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _loggerService = locator<LoggerService>();
  final _pushNotificationService = locator<PushNotificationsService>();
  final _analyticsService = locator<AnalyticsService>();
  final _navigationService = locator<NavigationService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authBottomNavService];

  AuthBottomNavTab get activeTab => _authBottomNavService.activeTab;
  int get activeIndex => _authBottomNavService.activeIndex;

  bool get reverse => _authBottomNavService.reverse;

  Future<void> onModelReady() async {
    await _pushNotificationService.registerDevice();
  }

  void onTabTap(int newIndex) {
    assert(0 <= newIndex && newIndex <= AuthBottomNavTab.values.length - 1);
    _loggerService.info(
      "AuthBottomNavViewModel - onTap(newIndex: $newIndex)",
    );

    _authBottomNavService.changeTap(newIndex);
  }

  void onAddLog() {
    _loggerService.info(
      "AuthBottomNavViewModel - onAddLog()",
    );

    _bottomSheetService.addLog();
  }

  Future<void> onMedLog() async {
    _analyticsService.logProfileViewAction(action: "med_log_click");

    _bottomSheetService.addMedLog();
    //_navigationService.navigateTo(Routes.medLogView);
  }

  Future<void> onRecreationLog() async {
    _loggerService.info(
      "AuthBottomNavViewModel - addRecLog()",
    );
    _bottomSheetService.addRecLog();
    // _analyticsService.logProfileViewAction(action: "recreation_log_click");

    // _navigationService.navigateTo(Routes.recreationLogView);
  }
}
