import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';

class BottomNavViewModel extends ReactiveViewModel {
  final _authService = locator<AuthService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authService];

  bool get isSignedIn => _authService.signedIn;
}
