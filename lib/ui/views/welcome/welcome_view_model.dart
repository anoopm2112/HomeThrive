import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class WelcomeViewModel extends BaseViewModel {
  final _analyticsService = locator<AnalyticsService>();
  final _navigationService = locator<NavigationService>();

  void onSignIn() {
    _analyticsService.logWelcomeViewAction(action: "login_click");

    _navigationService.navigateTo(Routes.loginView);
  }

  void onContinueWithoutAccount() {
    _analyticsService.logWelcomeViewAction(
      action: "continue_without_account_click",
    );

    _navigationService.clearStackAndShow(Routes.bottomNavView);
  }
}
