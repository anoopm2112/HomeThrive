import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding_item.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  List<OnboardingItem> get onboardingItems => Onboarding.onboardingItems;

  bool get isSignedIn => _authService.signedIn;

  void onSignIn() {
    _navigationService.navigateTo(Routes.loginView);
  }
}
