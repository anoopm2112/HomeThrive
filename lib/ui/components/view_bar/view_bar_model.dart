import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked/stacked.dart';

class ViewBarModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _bottomSheetService = locator<BottomSheetService>();

  bool get isSignedIn => _authService.signedIn; // TODO

  void onAlerts() {
    _bottomSheetService.alerts();
  }
}
