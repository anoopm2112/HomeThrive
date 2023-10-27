import 'package:fostershare/core/models/data/onboarding/onboarding.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding_item.dart';
import 'package:stacked/stacked.dart';

class GuestHomeViewModel extends BaseViewModel {
  List<OnboardingItem> get onboardingItems => Onboarding.onboardingItems;
}
