import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding_item.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class OnboardingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<OnboardingItem> get onboardingItems => Onboarding.onboardingItems;

  void onComplete() {
    _navigationService.clearStackAndShow(Routes.bottomNavView);
  }
}
