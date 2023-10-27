import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/dialog_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/push_notifications_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum LoginFormField {
  email,
  password,
  obscurePassword,
}

class LoginViewModel extends BaseViewModel
    with FormViewModelMixin<LoginFormField> {
  final _analyticsService = locator<AnalyticsService>();
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _pushNotificationsService = locator<PushNotificationsService>();
  final _localization = AppLocalizations.current;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  bool _signingIn = false;
  bool get signingIn => _signingIn;

  String _generalAuthErrorText;
  String get generalAuthErrorText => _generalAuthErrorText;

  LoginViewModel() {
    this.addAllFormFields(
      {
        LoginFormField.email: FormFieldModel<String>(
          validator: (email) => email != null &&
                  email.trim().isNotEmpty &&
                  EmailValidator.validate(email)
              ? null
              : _localization.enterValidEmail,
        ),
        LoginFormField.password: FormFieldModel<String>(
          validator: (password) =>
              password != null && password.trim().isNotEmpty
                  ? null
                  : _localization.enterPassword,
        ),
        LoginFormField.obscurePassword: FormFieldModel<bool>(
          value: true,
        ),
      },
    );
  }

  void onModelReady({
    @required TextEditingController emailController,
    @required TextEditingController passwordController,
  }) {
    this._emailController = emailController;
    this._passwordController = passwordController;
  }

  void onBack() {
    _navigationService.back();
  }

  void toggleObscurePassword() {
    this.updateField(
      LoginFormField.obscurePassword,
      value: !this.fieldValue(LoginFormField.obscurePassword),
    );

    notifyListeners();
  }

  @override
  void updateField<T>(
    LoginFormField key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) {
    super.updateField<T>(
      key,
      value: value,
      validationMessage: validationMessage,
      validator: validator,
    );

    notifyListeners();
  }

  void onForgotPassword() {
    _navigationService
        .navigateTo(Routes.forgotPasswordView)
        .then((_) => _clearForm());
  }

  void _clearForm() {
    this._generalAuthErrorText = null;

    this._emailController.clear();
    this._passwordController.clear();
    _setSigningIn(false);
  }

  void _setSigningIn(bool newSigningIn) {
    assert(newSigningIn != null);

    this._signingIn = newSigningIn;
    notifyListeners();
  }

  Future<void> onLogin() async {
    _loggerService.info(
      "LoginViewModel - onLogin()",
    );

    final bool validForm = this.validateForm();
    notifyListeners();

    if (validForm) {
      _setSigningIn(true);

      final String email = this.fieldValue<String>(LoginFormField.email);
      final String password = this.fieldValue<String>(LoginFormField.password);

      try {
        final SignInResult signInResult =
            await _authService.loginWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (signInResult.nextStep.signInStep ==
            "CONFIRM_SIGN_IN_WITH_NEW_PASSWORD") {
          _navigationService.navigateTo(Routes.confirmSignInView).then(
                (_) => _clearForm(),
              ); // TODO

        } else if (signInResult.isSignedIn) {
          if (_authService.currentUser.role != 3) {
            await _authService.signOut();
            _dialogService.onlyFosterParents().then(
                  (_) => _clearForm(),
                ); // TODO;
          } else {
            _analyticsService.logLogin();
            await _pushNotificationsService.init();
            _pushNotificationsService.registerDevice();
            _navigationService.clearStackAndShow(Routes.bottomNavView);
          }
        } else {
          throw Exception("");
        }
      } on UserNotFoundException catch (e, s) {
        this.updateField<String>(
          LoginFormField.email,
          validationMessage: _localization.invalidEmailOrPass,
        );
        this.updateField<String>(
          LoginFormField.password,
          validationMessage: _localization.invalidEmailOrPass, // TODO localize
        );

        _setSigningIn(false);

        _loggerService.error(
          "LoginViewModel - UserNotFoundException - User not found in the system",
          error: e,
          stackTrace: s,
        );
      } on PasswordResetRequiredException {
        await _authService.resetPassword(
          email: email,
        );
        _navigationService
            .navigateTo(
              Routes.confirmationCodeView,
              arguments: ConfirmationCodeViewArguments(
                email: email,
              ),
            )
            .then(
              (_) => _clearForm(),
            );

        _loggerService.warn(
          "LoginViewModel - PasswordResetRequiredException - Password reset required",
        );
      } on TooManyRequestsException catch (e, s) {
        this._generalAuthErrorText = _localization.tooManyAttempts;
        _setSigningIn(false);

        _loggerService.error(
          "LoginViewModel - TooManyRequestsException - User sign in requests throttled",
          error: e,
          stackTrace: s,
        );
      } on TooManyFailedAttemptsException catch (e, s) {
        this._generalAuthErrorText = _localization.tooManyAttempts;
        _setSigningIn(false);

        _loggerService.error(
          "LoginViewModel - TooManyFailedAttemptsException - Too many sign in attempts for a specific user",
          error: e,
          stackTrace: s,
        );
      } on NotAuthorizedException catch (e, s) {
        this.updateField<String>(
          LoginFormField.email,
          validationMessage: _localization.invalidEmailOrPass,
        );
        this.updateField<String>(
          LoginFormField.password,
          validationMessage: _localization.invalidEmailOrPass, // TODO localize
        );

        _setSigningIn(false);

        _loggerService.error(
          "LoginViewModel - UserNotFoundException - User not found in the system",
          error: e,
          stackTrace: s,
        );
        // _loggerService.error(
        //   "LoginViewModel - AuthException - General Exception, something went wrong",
        //   error: e,
        //   stackTrace: s,
        // );

        // this._generalAuthErrorText = e.message ?? _localization.userDisabled;
        // _setSigningIn(false);
      } catch (e, s) {
        _loggerService.error(
          "LoginViewModel - AuthException - General Exception, something went wrong",
          error: e,
          stackTrace: s,
        );

        this._generalAuthErrorText = _localization.genericError;
        _setSigningIn(false);
      }
    }
  }
}
