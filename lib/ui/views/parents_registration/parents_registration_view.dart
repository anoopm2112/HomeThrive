import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/parents_registration/parents_registration_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/general_view_bar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:stacked/stacked.dart';

class ParentsRegistrationView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final textTheme = theme.textTheme;

    return ViewModelBuilder<ParentsRegistrationViewModel>.reactive(
      viewModelBuilder: () => ParentsRegistrationViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.dialogBackgroundColor,
        body: WillPopScope(
          onWillPop: model.onWillPop,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: defaultViewPaddingHorizontal,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        defaultViewSpacingTop,
                        GestureDetector(
                          onTap: () =>
                              model.setBusyForObject("SubmittingKey", false),
                          child: GeneralViewBar(
                            title: localization.register,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.isBusy)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: defaultViewPaddingHorizontal,
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(height: 12),
                          Text(
                            localization.welcomeToFS,
                            style: textTheme.bodyText1,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "${localization.primaryParent} 1",
                            style: textTheme.headline3.copyWith(
                              fontSize: getResponsiveSmallFontSize(context),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Flexible(
                                child: AppTextField(
                                  labelText: localization.firstName,
                                  textInputAction: TextInputAction.next,
                                  initialText: model.fieldValue<String>(
                                    ParentsRegisterFormField.ppFirstName,
                                  ),
                                  onChanged: (firstName) =>
                                      model.onFieldChanged(
                                    key: ParentsRegisterFormField.ppFirstName,
                                    value: firstName.trim(),
                                  ),
                                  errorText: model.fieldValidationMessage(
                                    ParentsRegisterFormField.ppFirstName,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                child: AppTextField(
                                  labelText: localization.lastName,
                                  textInputAction: TextInputAction.next,
                                  initialText: model.fieldValue(
                                    ParentsRegisterFormField.ppLastName,
                                  ),
                                  onChanged: (lastName) => model.onFieldChanged(
                                    key: ParentsRegisterFormField.ppLastName,
                                    value: lastName.trim(),
                                  ),
                                  errorText: model.fieldValidationMessage(
                                    ParentsRegisterFormField.ppLastName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          AppTextField.phoneNumber(
                            initialText: model.fieldValue(
                              ParentsRegisterFormField.ppPhoneNumber,
                            ),
                            onChanged: (phoneNumber) =>
                                model.updateField<String>(
                              ParentsRegisterFormField.ppPhoneNumber,
                              value: phoneNumber.trim(),
                            ),
                            errorText: model.fieldValidationMessage(
                              ParentsRegisterFormField.ppPhoneNumber,
                            ),
                          ),
                          SizedBox(height: 20),
                          AppTextField(
                            labelText: localization.occupation,
                            initialText: model.fieldValue(
                              ParentsRegisterFormField.ppOccupation,
                            ),
                            onChanged: (occupation) => model.onFieldChanged(
                              key: ParentsRegisterFormField.ppOccupation,
                              value: occupation.trim(),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "${localization.primaryParent} 2",
                            style: textTheme.headline3.copyWith(
                              fontSize: getResponsiveSmallFontSize(context),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Flexible(
                                child: AppTextField(
                                  labelText: localization.firstName,
                                  textInputAction: TextInputAction.next,
                                  initialText: model.fieldValue(
                                    ParentsRegisterFormField.spFirstName,
                                  ),
                                  onChanged: (firstName) =>
                                      model.onFieldChanged(
                                    key: ParentsRegisterFormField.spFirstName,
                                    value: firstName.trim(),
                                  ),
                                  errorText: model.fieldValidationMessage(
                                    ParentsRegisterFormField.spFirstName,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                child: AppTextField(
                                  labelText: localization.lastName,
                                  textInputAction: TextInputAction.next,
                                  initialText: model.fieldValue(
                                    ParentsRegisterFormField.spLastName,
                                  ),
                                  onChanged: (lastName) => model.onFieldChanged(
                                    key: ParentsRegisterFormField.spLastName,
                                    value: lastName.trim(),
                                  ),
                                  errorText: model.fieldValidationMessage(
                                    ParentsRegisterFormField.spLastName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          AppTextField.phoneNumber(
                            initialText: model.fieldValue(
                              ParentsRegisterFormField.spPhoneNumber,
                            ),
                            onChanged: (phoneNumber) =>
                                model.updateField<String>(
                              ParentsRegisterFormField.spPhoneNumber,
                              value: phoneNumber.trim(),
                            ),
                            errorText: model.fieldValidationMessage(
                              ParentsRegisterFormField.spPhoneNumber,
                            ),
                          ),
                          SizedBox(height: 20),
                          AppTextField(
                            labelText: localization.occupation,
                            initialText: model.fieldValue(
                              ParentsRegisterFormField.spOccupation,
                            ),
                            onChanged: (occupation) => model.onFieldChanged(
                              key: ParentsRegisterFormField.spOccupation,
                              value: occupation.trim(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(140, 50),
                              ),
                              onPressed:
                                  model.submitting ? null : model.onContinue,
                              child: model.submitting
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.dialogBackgroundColor,
                                      ),
                                    )
                                  : Text(
                                      localization.continueStr,
                                      style: textTheme.button,
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                                "${localization.termsAndConditions}  |  ${localization.privacyPolicy}"),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
