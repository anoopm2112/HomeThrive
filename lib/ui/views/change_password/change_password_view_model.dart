import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum ChangePasswordFormField {
  currentPassword,
  newPassword,
  confirmPassword,
}

class ChangePasswordViewModel extends BaseViewModel
    with FormViewModelMixin<ChangePasswordFormField> {
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();
  final _toastService = locator<ToastService>();
  final AppLocalizations localization;

  final _obscureFormField = <ChangePasswordFormField, bool>{
    ChangePasswordFormField.currentPassword: true,
    ChangePasswordFormField.newPassword: true,
    ChangePasswordFormField.confirmPassword: true,
  };

  final String _changingPassword = "ChangingPasswordKey";
  bool get changingPassword => this.busy(this._changingPassword);

  ChangePasswordViewModel({this.localization}) {
    this.addAllFormFields({
      ChangePasswordFormField.currentPassword: FormFieldModel(
        validator: (currentPassword) =>
            currentPassword != null && currentPassword.isNotEmpty
                ? null
                : localization.enterCurrentPassword,
      ),
      ChangePasswordFormField.newPassword: FormFieldModel(
        validator: (newPassword) =>
            newPassword != null && newPassword.isNotEmpty
                ? newPassword !=
                        this.fieldValue(ChangePasswordFormField.confirmPassword)
                    ? localization.passwordNotMatch
                    : null
                : localization.enterNewPassword,
      ),
      ChangePasswordFormField.confirmPassword: FormFieldModel(
        validator: (confirmPassword) =>
            confirmPassword != null && confirmPassword.isNotEmpty
                ? confirmPassword !=
                        this.fieldValue(ChangePasswordFormField.newPassword)
                    ? localization.passwordNotMatch
                    : null
                : localization.confirmPassword,
      ),
    });
  }

  bool obscureFormField(ChangePasswordFormField field) {
    assert(this._obscureFormField.containsKey(field));

    return this._obscureFormField[field];
  }

  void toggleObscureFormField(ChangePasswordFormField field) {
    assert(this._obscureFormField.containsKey(field));

    this._obscureFormField[field] = !this._obscureFormField[field];
    notifyListeners();
  }

  Future<bool> onChangePassword() async {
    final bool validForm = this.validateForm();
    notifyListeners();
    if (validForm) {
      this.setBusyForObject(this._changingPassword, true);
      try {
        final UpdatePasswordResult result = await _authService.changePassword(
          oldPassword: this.fieldValue(
            ChangePasswordFormField.currentPassword,
          ),
          newPassword: this.fieldValue(
            ChangePasswordFormField.newPassword,
          ),
        );
        _toastService.passwordChanged(
          () => this.setBusyForObject(this._changingPassword, false),
        );
        return true;
      } catch (e) {
        _toastService.passwordChangeError(
          () => this.setBusyForObject(this._changingPassword, false),
        );
      }
    }

    return false;
  }
}
