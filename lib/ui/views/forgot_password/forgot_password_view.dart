import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/forgot_password/forgot_password_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
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
                    onTap: model.onBack, // TODO
                    child: Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    localization.forgotPassword,
                    style: textTheme.headline1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    localization.recoveryCode,
                    style: textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 28,
                    child: model.generalErrorText != null
                        ? Center(
                            child: Text(
                              model.generalErrorText,
                              style: textTheme.bodyText1.copyWith(
                                color: theme.errorColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  AppTextField(
                    autoFocus: true,
                    labelText: localization.email,
                    onChanged: model.onEmailChanged,
                    errorText: model.emailErrorText,
                  ),
                  SizedBox(height: 22),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed:
                          model.resettingPassword ? null : model.onSubmit,
                      child: model.resettingPassword
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            )
                          : Text(
                              localization.submit,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF), // TODO
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "${localization.termsAndConditions} | ${localization.privacyPolicy}", // TODO
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
