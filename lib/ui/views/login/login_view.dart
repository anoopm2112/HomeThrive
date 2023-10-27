import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/login/login_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class LoginView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    final passwordFocusNode = useFocusNode();
    final emailcontroller = useTextEditingController();
    final passwordController = useTextEditingController();

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.onModelReady(
        emailController: emailcontroller,
        passwordController: passwordController,
      ),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.dialogBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 46), // TODO
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          localization.signIn,
                          style: textTheme.headline1,
                        ),
                      ),
                      GestureDetector(
                        onTap: model.onBack,
                        child: Icon(
                          Icons.close,
                          size: 32,
                          color: Color(0xFF95A1AC), // TODO
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    localization.welcomeToFosterShare,
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
                    controller: emailcontroller,
                    autoFocus: true,
                    labelText: localization.email,
                    onChanged: (email) => model.updateField(
                      LoginFormField.email,
                      value: email.trim(),
                    ),
                    errorText: model.fieldValidationMessage(
                      LoginFormField.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    labelText: localization.password,
                    onChanged: (password) => model.updateField(
                      LoginFormField.password,
                      value: password.trim(),
                    ),
                    errorText: model.fieldValidationMessage(
                      LoginFormField.password,
                    ),
                    obscureText: model.fieldValue<bool>(
                      LoginFormField.obscurePassword,
                    ),
                    textInputAction: TextInputAction.done,
                    suffixIcon: GestureDetector(
                      onTap: model.toggleObscurePassword,
                      child: Icon(
                        model.fieldValue<bool>(
                          LoginFormField.obscurePassword,
                        )
                            ? Icons.visibility
                            : Icons.visibility_off_sharp,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: model.onForgotPassword,
                            child: Text(
                              "${localization.forgotPassword}?",
                              style: TextStyle(
                                color: AppColors.black900,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          child: ElevatedButton(
                            onPressed: model.signingIn ? null : model.onLogin,
                            child: model.signingIn
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.dialogBackgroundColor,
                                    ),
                                  )
                                : Text(
                                    localization.signIn,
                                    style: textTheme.button,
                                  ),
                          ),
                        ),
                      ],
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
