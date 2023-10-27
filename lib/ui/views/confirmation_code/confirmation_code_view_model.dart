import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:stacked/stacked.dart';

class ConfirmationCodeViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  final _localization = AppLocalizations.current;

  TextEditingController _confirmationCodeController;
  String _email;
  String _confirmationCode;
  String _confirmationCodeErrorText;
  bool get _validConfirmationCode =>
      _confirmationCode != null && _confirmationCode.length == 6;

  String _generalErrorText;
  String get formErrorText => _confirmationCodeErrorText ?? _generalErrorText;

  bool get _validForm => formErrorText == null;

  void onModelReady({
    @required String email,
    @required TextEditingController confirmationCodeController,
  }) {
    this._email = email;
    this._confirmationCodeController = confirmationCodeController;
  }

  void onBack() {
    _navigationService.back();
  }

  void onConfirmationCodeChanged(String newConfirmationCode) {
    this._confirmationCode = newConfirmationCode;
  }

  Future<void> onResendCode() async {
    try {
      final ResetPasswordResult resetPasswordResult =
          await _authService.resetPassword(
        email: this._email,
      );

      if (resetPasswordResult.nextStep.updateStep ==
          "CONFIRM_RESET_PASSWORD_WITH_CODE") {
        _toastService.newCodeSent(
          onDismiss: () => _confirmationCodeController.clear(),
        );
      } else {
        throw Exception("Password did not reset correctly");
      }
    } catch (e, s) {
      _loggerService.error(
        "ConfirmationCodeViewModel - General Error",
        error: e,
        stackTrace: s,
      );
    }
  }

  void _handleFormErrors() {
    this._confirmationCodeErrorText = null;
    if (!this._validConfirmationCode) {
      this._confirmationCodeErrorText = _localization.enterConfirmationCode;
    }

    this._generalErrorText = null;
    notifyListeners();
  }

  void onNext() {
    _handleFormErrors();
    if (this._validForm) {
      _navigationService
          .navigateTo(
            Routes.resetPasswordView,
            arguments: ResetPasswordViewArguments(
              email: this._email,
              confirmationCode: this._confirmationCode,
            ),
          )
          .then<void>(
            (result) => this.clearForm(result as String),
          );
    }
  }

  void clearForm(String result) {
    _confirmationCodeController.clear();
    if (result == "incorrect") {
      this._confirmationCodeErrorText = _localization.incorrectConfirmationCode;
    } else if (result == "expired") {
      this._confirmationCodeErrorText = _localization.expiredConfirmationCode;
    }
  }
}
