import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/navigation_service.dart';

// TODO delete?
class OnboardingService {
  final _navigationService = locator<NavigationService>();

  void onboard() {
    final bool register = true;
    if (register) {
      _navigationService.navigateTo(Routes.parentsRegistrationView);
    }

    final bool requestPermissions = true;
    if (requestPermissions) {}
  }
}
