import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/dialog_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum ConfirmSignInFormField {
  newPassword,
  obscureNewPassword,
  confirmPassword,
  obscureConfirmPassword,
}

class ConfirmSignInViewModel extends BaseViewModel
    with FormViewModelMixin<ConfirmSignInFormField> {
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();

  final _localization = AppLocalizations.current;

  String _generalAuthErrorText;
  String get generalAuthErrorText => _generalAuthErrorText;

  bool _submitting = false;
  bool get submitting => _submitting;

  ConfirmSignInViewModel() {
    this.addAllFormFields(
      {
        ConfirmSignInFormField.newPassword: FormFieldModel<String>(
          validator: (newPassword) => newPassword != null &&
                  newPassword.trim().isNotEmpty
              ? newPassword ==
                      this.fieldValue(ConfirmSignInFormField.confirmPassword)
                  ? null
                  : _localization.passwordMustMatch
              : _localization.enterPassword,
        ),
        ConfirmSignInFormField.obscureNewPassword: FormFieldModel<bool>(
          value: true,
        ),
        ConfirmSignInFormField.confirmPassword: FormFieldModel<String>(
          validator: (confirmPassword) =>
              confirmPassword != null && confirmPassword.trim().isNotEmpty
                  ? confirmPassword ==
                          this.fieldValue(ConfirmSignInFormField.newPassword)
                      ? null
                      : _localization.passwordMustMatch
                  : _localization.enterPassword,
        ),
        ConfirmSignInFormField.obscureConfirmPassword: FormFieldModel<bool>(
          value: true,
        ),
      },
    );
  }

  void onBack() {
    _navigationService.back();
  }

  @override
  void updateField<T>(
    ConfirmSignInFormField key, {
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

  void toggleObscurePasswordField(ConfirmSignInFormField key) {
    assert(
      key == ConfirmSignInFormField.obscureNewPassword ||
          key == ConfirmSignInFormField.obscureConfirmPassword,
    );

    this.updateField<bool>(
      key,
      value: !this.fieldValue<bool>(key),
    );

    notifyListeners();
  }

  void _setSubmitting(bool newSubmitting) {
    assert(newSubmitting != null);

    this._submitting = newSubmitting;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    final bool validForm =
        this.validateForm(); // TODO should call update field?
    notifyListeners();

    if (validForm) {
      _setSubmitting(true);

      try {
        final SignInResult signInResult =
            await _authService.confirmSignInWithPassword(
          newPassword: this.fieldValue<String>(
            ConfirmSignInFormField.newPassword,
          ),
        );

        if (signInResult.isSignedIn) {
          if (_authService.currentUser.role != 3) {
            await _authService.signOut();
            _dialogService.onlyFosterParents();
          }

          _navigationService.clearStackAndShow(Routes.parentsRegistrationView);
        } else {
          throw Exception();
        }
      } catch (e, s) {
        _loggerService.error(
          "ConfirmSignInViewModel - General Exception, couldn't confirm new password",
          error: e,
          stackTrace: s,
        );

        this._generalAuthErrorText = _localization.genericError;
        _setSubmitting(false);
      }
    }
  }
}
