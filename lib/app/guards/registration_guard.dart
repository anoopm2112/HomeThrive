import 'package:auto_route/auto_route.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';

class RegistrationGuard extends RouteGuard {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  @override
  Future<bool> canNavigate(
    ExtendedNavigatorState<RouterBase> navigator,
    String routeName,
    Object arguments,
  ) async {
    // TODO check user details
    // TODO if signed in & needs to register. Launch first run flow

    final bool register = await _authService.getAuthStatus();
    if (register) {
      _navigationService.navigateTo(
        Routes.parentsRegistrationView,
      );
    }
  }
}
