import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/confirmation_code/confirmation_code_view_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';

class ConfirmationCodeView extends HookWidget {
  final String email;

  const ConfirmationCodeView({
    Key key,
    this.email,
  })  : assert(email != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    final confirmationCodeController = useTextEditingController();
    return ViewModelBuilder<ConfirmationCodeViewModel>.reactive(
      viewModelBuilder: () => ConfirmationCodeViewModel(),
      onModelReady: (model) => model.onModelReady(
        email: email,
        confirmationCodeController: confirmationCodeController,
      ),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
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
                    localization.emailSent,
                    style: textTheme.headline1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${localization.enterVerificationCode} $email",
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
                  PinCodeTextField(
                    controller: confirmationCodeController,
                    appContext: context,
                    length: 6,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    onChanged:
                        model.onConfirmationCodeChanged, // TODO textstyle
                    cursorColor: AppColors.orange500,

                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: screenWidthPercentage(
                        context,
                        percentage: 13.3,
                      ),
                      fieldWidth: screenWidthPercentage(
                        context,
                        percentage: 13.3,
                      ),
                      borderWidth: 2,
                      activeColor: AppColors.orange500, // TODO
                      selectedColor: AppColors.orange500,
                      inactiveColor: Color(0xFFE6E6E6),
                      // activeFillColor: hasError ? Colors.orange : Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: GestureDetector(
                            onTap: model.onResendCode,
                            child: Text(
                              localization.resendCode,
                              style: TextStyle(
                                color: AppColors.black900,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: model.onNext,
                        child: Text(
                          localization.next,
                          style: textTheme.button,
                        ),
                      ),
                    ],
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
