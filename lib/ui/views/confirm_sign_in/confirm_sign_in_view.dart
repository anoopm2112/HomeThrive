import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/confirm_sign_in/confirm_sign_in_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class ConfirmSignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ConfirmSignInViewModel>.reactive(
      viewModelBuilder: () => ConfirmSignInViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.dialogBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 28),
                  GestureDetector(
                    onTap: model.onBack, // TODO widget
                    child: Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    localization.setPassword,
                    style: textTheme.headline1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    localization.setPasswordRegular,
                    style: textTheme.bodyText1,
                  ),
                  model.generalAuthErrorText != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              model.generalAuthErrorText,
                              style: textTheme.bodyText1.copyWith(
                                color: theme.errorColor,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(height: 28),
                  AppTextField(
                    labelText: localization.newPassword,
                    autoFocus: true,
                    onChanged: (newPasword) => model.updateField<String>(
                      ConfirmSignInFormField.newPassword,
                      value: newPasword,
                    ),
                    obscureText: model.fieldValue<bool>(
                      ConfirmSignInFormField.obscureNewPassword,
                    ),
                    errorText: model.fieldValidationMessage(
                      ConfirmSignInFormField.newPassword,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => model.toggleObscurePasswordField(
                        ConfirmSignInFormField.obscureNewPassword,
                      ),
                      child: Icon(
                        model.fieldValue<bool>(
                          ConfirmSignInFormField.obscureNewPassword,
                        )
                            ? Icons.visibility
                            : Icons.visibility_off_sharp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    labelText: localization.confirmPasswordShort,
                    autoFocus: true,
                    onChanged: (newPasword) => model.updateField<String>(
                      ConfirmSignInFormField.confirmPassword,
                      value: newPasword,
                    ),
                    obscureText: model.fieldValue<bool>(
                      ConfirmSignInFormField.obscureConfirmPassword,
                    ),
                    errorText: model.fieldValidationMessage(
                      ConfirmSignInFormField.confirmPassword,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => model.toggleObscurePasswordField(
                        ConfirmSignInFormField.obscureConfirmPassword,
                      ),
                      child: Icon(
                        model.fieldValue<bool>(
                          ConfirmSignInFormField.obscureConfirmPassword,
                        )
                            ? Icons.visibility
                            : Icons.visibility_off_sharp,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: model.submitting ? null : model.onSubmit,
                      child: model.submitting
                          ? CircularProgressIndicator(
                              // TODO widget
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            )
                          : Text(
                              localization.submit,
                              style: textTheme.button,
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "${localization.termsAndConditions} | ${localization.privacyPolicy}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
