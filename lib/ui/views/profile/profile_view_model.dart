import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();

  bool get isSignedIn => _authService.signedIn;
  bool get showNotificationButton => this.isSignedIn;
}
