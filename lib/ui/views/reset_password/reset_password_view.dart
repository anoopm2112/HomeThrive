import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/reset_password/reset_password_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String confirmationCode;

  const ResetPasswordView({
    Key key,
    @required this.email,
    @required this.confirmationCode,
  })  : assert(email != null),
        assert(confirmationCode != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ResetPasswordViewModel>.reactive(
      viewModelBuilder: () => ResetPasswordViewModel(),
      onModelReady: (model) => model.onModelReady(
        email: email,
        confirmationCode: confirmationCode,
      ),
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
                    localization.resetPassword, // TODO
                    style: textTheme.headline1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    localization.checkConfirmationCode, // TODO
                    style: textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 28,
                    child: model.formErrorText != null
                        ? Center(
                            child: Text(
                              model.formErrorText,
                              style: textTheme.bodyText1.copyWith(
                                color: theme.errorColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  AppTextField(
                    labelText: localization.newPassword,
                    onChanged: model.onNewPasswordChanged,
                    obscureText: model.obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: model.toggleObscurePassword,
                      child: Icon(
                        Icons.remove_red_eye_sharp,
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
