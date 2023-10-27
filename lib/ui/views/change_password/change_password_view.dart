import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/change_password/change_password_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      viewModelBuilder: () =>
          ChangePasswordViewModel(localization: localization),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            localization.changePassword,
            style: theme.appBarTheme.titleTextStyle.copyWith(
              fontSize: getResponsiveMediumFontSize(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: defaultViewChildPaddingHorizontal,
          child: Column(
            children: [
              SizedBox(height: 14),
              Text(
                localization.enterCurrentAndNewPassword,
                style: textTheme.bodyText2,
              ),
              SizedBox(height: 14),
              AppTextField(
                controller: currentPasswordController,
                labelText: localization.currentPassword,
                keyboardType: TextInputType.visiblePassword, // TODO check
                textInputAction: TextInputAction.next,
                autoFocus: true,
                onChanged: (currentPassword) => model.updateField<String>(
                  ChangePasswordFormField.currentPassword,
                  value: currentPassword,
                ),
                errorText: model.fieldValidationMessage(
                  ChangePasswordFormField.currentPassword,
                ),
                obscureText: model.obscureFormField(
                  ChangePasswordFormField.currentPassword,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => model.toggleObscureFormField(
                    ChangePasswordFormField.currentPassword,
                  ),
                  child: Icon(
                    model.obscureFormField(
                      ChangePasswordFormField.currentPassword,
                    )
                        ? Icons.visibility
                        : Icons.visibility_off_sharp,
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppTextField(
                controller: newPasswordController,
                labelText: localization.newPassword,
                textInputAction: TextInputAction.next,
                onChanged: (newPassword) => model.updateField<String>(
                  ChangePasswordFormField.newPassword,
                  value: newPassword,
                ),
                errorText: model.fieldValidationMessage(
                  ChangePasswordFormField.newPassword,
                ),
                obscureText: model.obscureFormField(
                  ChangePasswordFormField.newPassword,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => model.toggleObscureFormField(
                    ChangePasswordFormField.newPassword,
                  ),
                  child: Icon(
                    model.obscureFormField(
                      ChangePasswordFormField.newPassword,
                    )
                        ? Icons.visibility
                        : Icons.visibility_off_sharp,
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppTextField(
                controller: confirmPasswordController,
                labelText: localization.confirmPasswordShort,
                textInputAction: TextInputAction.done,
                onChanged: (confirmPassword) => model.updateField<String>(
                  ChangePasswordFormField.confirmPassword,
                  value: confirmPassword,
                ),
                errorText: model.fieldValidationMessage(
                  ChangePasswordFormField.confirmPassword,
                ),
                obscureText: model.obscureFormField(
                  ChangePasswordFormField.confirmPassword,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => model.toggleObscureFormField(
                    ChangePasswordFormField.confirmPassword,
                  ),
                  child: Icon(
                    model.obscureFormField(
                      ChangePasswordFormField.confirmPassword,
                    )
                        ? Icons.visibility
                        : Icons.visibility_off_sharp,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: model.changingPassword
                        ? null
                        : () async {
                            final bool passwordChanged =
                                await model.onChangePassword();
                            if (passwordChanged) {
                              // TODO pass back?
                              currentPasswordController.clear();
                              newPasswordController.clear();
                              confirmPasswordController.clear();
                            }
                          },
                    child: model.changingPassword
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.dialogBackgroundColor,
                            ),
                          )
                        : Text(
                            localization.changePassword,
                            style: textTheme.button,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
