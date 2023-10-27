import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _localization = AppLocalizations.current;

  bool _resettingPassword = false;
  bool get resettingPassword => _resettingPassword;

  String _email;
  String _emailErrorText;
  String get emailErrorText => _emailErrorText;
  bool get _validEmail =>
      this._email != null && EmailValidator.validate(this._email);

  String _generalErrorText;
  String get generalErrorText => _generalErrorText;

  void onBack() {
    _navigationService.back();
  }

  void onEmailChanged(String newEmail) {
    this._email = newEmail.trim();
  }

  void _handleFormErrors() {
    this._emailErrorText = null;
    if (!this._validEmail) {
      this._emailErrorText = _localization.invalidEmail;
    }

    this._generalErrorText = null;
    notifyListeners();
  }

  void _setResettingPassword(bool resettingPassword) {
    this._resettingPassword = resettingPassword;
    notifyListeners();
  }

  void _navigateToConfirmationCodeView() {
    _navigationService
        .navigateTo(
          Routes.confirmationCodeView,
          arguments: ConfirmationCodeViewArguments(email: this._email),
        )
        .then(
          (_) => _setResettingPassword(false),
        );
  }

// TODO clear errors but leave email
  Future<void> onSubmit() async {
    _handleFormErrors();

    if (this._validEmail) {
      try {
        _setResettingPassword(true);

        final resetPasswordResult = await _authService.resetPassword(
          email: this._email.trim(),
        );

        if (resetPasswordResult.nextStep.updateStep ==
            "CONFIRM_RESET_PASSWORD_WITH_CODE") {
          _navigateToConfirmationCodeView();
        } else {
          throw Exception(
              "Call to auth service worked, but the password did not reset");
        }
      } on PasswordResetRequiredException {
        _navigateToConfirmationCodeView(); // TODO is this corrext?

        _loggerService.warn(
          "ForgotPasswordViewModel - PasswordResetRequiredException - Password resert required",
        );
      } catch (e, s) {
        // TODO
        this._generalErrorText = _localization.genericError;
        _setResettingPassword(false);

        _loggerService.error(
          "ForgotPasswordViewModel - AuthException - General Exception, something went wrong",
          error: e,
          stackTrace: s,
        );
      }
    }
  }
}
