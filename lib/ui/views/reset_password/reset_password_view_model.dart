import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:meta/meta.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:stacked/stacked.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _localization = AppLocalizations.current;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _submitting = false;
  bool get submitting => _submitting;

  String _email;
  String _confirmationCode;
  String _newPassword;
  String _newPasswordErrorText;
  bool get _validEmail => _newPassword != null && _newPassword.isNotEmpty;
  String _generalErrorText;
  String get formErrorText => _newPasswordErrorText ?? _generalErrorText;
  bool get _validForm => formErrorText == null;

  void onModelReady({
    @required String email,
    @required String confirmationCode,
  }) {
    assert(email != null);
    assert(confirmationCode != null);

    this._email = email;
    this._confirmationCode = confirmationCode;
  }

  void onConfirmationCodeChanged(String newConfirmationCode) {
    this._confirmationCode = newConfirmationCode;
  }

  void onNewPasswordChanged(String newPassword) {
    this._newPassword = newPassword;
  }

  void toggleObscurePassword() {
    this._obscurePassword = !this._obscurePassword;
    notifyListeners();
  }

  void onBack() {
    _navigationService.back();
  }

  void _setSubmitting(bool submitting) {
    this._submitting = submitting;
    notifyListeners();
  }

  void _handleFormErrors() {
    this._newPasswordErrorText = null;
    if (!this._validEmail) {
      this._newPasswordErrorText = _localization.enterPassword;
    }

    this._generalErrorText = null;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    _handleFormErrors();
    if (this._validForm) {
      _setSubmitting(true);
      try {
        final UpdatePasswordResult updatePasswordResult =
            await _authService.confirmPassword(
          email: this._email,
          newPassword: this._newPassword,
          confirmationCode: this._confirmationCode,
        );

        _navigationService.clearStackUntil(Routes.loginView);
      } on CodeMismatchException catch (e, s) {
        _loggerService.error(
          "ResetPasswordViewModel - incorrect code used",
          error: e,
          stackTrace: s,
        );

        _navigationService.back(result: "incorrect"); // TODO make better
      } on CodeExpiredException catch (e, s) {
        _loggerService.error(
          "ResetPasswordViewModel - expired code used",
          error: e,
          stackTrace: s,
        );

        _navigationService.back(result: "expired"); // TODO make better

      } catch (e, s) {
        _setSubmitting(false);
        _generalErrorText = _localization.genericError;

        _loggerService.error(
          "ResetPasswordViewModel - error finishing reset password flow",
          error: e,
          stackTrace: s,
        );
      }
    }
  }
}
