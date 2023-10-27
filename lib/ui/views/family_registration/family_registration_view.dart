import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/family_registration/family_registration_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/general_view_bar.dart';
import 'package:stacked/stacked.dart';

class FamilyRegistrationView extends StatelessWidget {
  final Family family;

  const FamilyRegistrationView({
    Key key,
    @required this.family,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<FamilyRegistrationViewModel>.reactive(
      viewModelBuilder: () => FamilyRegistrationViewModel(
        family: this.family,
      ),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.dialogBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: defaultViewPaddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultViewSpacingTop,
                GeneralViewBar(title: localization.register),
                SizedBox(height: 22),
                Text(
                  localization.fosterDetails,
                  style: textTheme.headline3.copyWith(
                    fontSize: getResponsiveSmallFontSize(context),
                  ),
                ),
                SizedBox(height: 20),
                AppTextField(
                  labelText: localization.address,
                  textInputAction: TextInputAction.next,
                  initialText: model.fieldValue<String>(
                    FamilyRegistrationFormField.address,
                  ),
                  onChanged: (address) => model.updateField<String>(
                    FamilyRegistrationFormField.address,
                    value: address,
                  ),
                ),
                SizedBox(height: 20),
                AppTextField(
                  labelText: localization.zipCode,
                  textInputAction: TextInputAction.next,
                  initialText: model.fieldValue<String>(
                    FamilyRegistrationFormField.zipCode,
                  ),
                  errorText: model.fieldValidationMessage(
                    FamilyRegistrationFormField.zipCode,
                  ),
                  onChanged: (zipCode) => model.updateField<String>(
                    FamilyRegistrationFormField.zipCode,
                    value: zipCode,
                  ),
                ),
                SizedBox(height: 20),
                AppTextField(
                  labelText: localization.licenseNumber,
                  textInputAction: TextInputAction.next,
                  initialText: model.fieldValue<String>(
                    FamilyRegistrationFormField.license,
                  ),
                  onChanged: (licenseNumber) => model.updateField<String>(
                    FamilyRegistrationFormField.license,
                    value: licenseNumber,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  // TODO
                  dropdownColor: theme.dialogBackgroundColor,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: localization.primaryLanguage,
                  ),
                  value: model
                          .fieldValue<String>(
                            FamilyRegistrationFormField.languageCode,
                          )
                          ?.toLowerCase() ??
                      "en-us",
                  onChanged: (languageCode) => model.updateField<String>(
                    FamilyRegistrationFormField.languageCode,
                    value: languageCode,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "en-us",
                      child: Text(
                        "English",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "es",
                      child: Text(
                        "Spanish",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        // TODO make into widget
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 2,
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        onPressed: model.onBack,
                        child: Text(
                          localization.previous,
                          style: TextStyle(
                            color: Color(0xFF57636C), // TODO
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: model.submitting ? null : model.onRegister,
                        child: model.submitting
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.dialogBackgroundColor,
                                ),
                              )
                            : Text(
                                localization.register,
                                style: textTheme.button,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
