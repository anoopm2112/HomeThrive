import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/edit_profile/edit_profile_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/full_name_text_field.dart';
import 'package:stacked/stacked.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            localization.editProfile,
            style: theme.appBarTheme.titleTextStyle.copyWith(
              fontSize: getResponsiveMediumFontSize(context),
            ),
          ),
        ),
        body: SafeArea(
          child: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${localization.primaryParent} 1",
                        style: textTheme.headline3.copyWith(
                          fontSize: getResponsiveSmallFontSize(context),
                        ),
                      ),
                      SizedBox(height: 16),
                      FullNameTextFieldRow(
                        initialFirstName: model.fieldValue<String>(
                          EditProfileFormField.ppFirstName,
                        ),
                        onFirstNameChanged: (firstName) =>
                            model.updateField<String>(
                          EditProfileFormField.ppFirstName,
                          value: firstName,
                        ),
                        firstNameErrorText: model.fieldValidationMessage(
                          EditProfileFormField.ppFirstName,
                        ),
                        initialLastName: model.fieldValue<String>(
                          EditProfileFormField.ppLastName,
                        ),
                        onLastNameChanged: (lastName) =>
                            model.updateField<String>(
                          EditProfileFormField.ppLastName,
                          value: lastName,
                        ),
                        lastNameErrorText: model.fieldValidationMessage(
                          EditProfileFormField.ppLastName,
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField.phoneNumber(
                        initialText: model.fieldValue(
                          EditProfileFormField.ppPhoneNumber,
                        ),
                        onChanged: (phoneNumber) => model.updateField<String>(
                          EditProfileFormField.ppPhoneNumber,
                          value: phoneNumber,
                        ),
                        errorText: model.fieldValidationMessage(
                          EditProfileFormField.ppPhoneNumber,
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField(
                        labelText: localization.occupation,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          EditProfileFormField.ppOccupation,
                        ),
                        onChanged: (occupation) => model.onFieldChanged(
                          key: EditProfileFormField.ppOccupation,
                          value: occupation,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${localization.primaryParent} 2",
                        style: textTheme.headline3.copyWith(
                          fontSize: getResponsiveSmallFontSize(context),
                        ),
                      ),
                      SizedBox(height: 16),
                      FullNameTextFieldRow(
                        initialFirstName:
                            model.fieldValue(EditProfileFormField.spFirstName),
                        onFirstNameChanged: (firstName) =>
                            model.updateField<String>(
                          EditProfileFormField.spFirstName,
                          value: firstName.trim(),
                        ),
                        firstNameErrorText: model.fieldValidationMessage(
                          EditProfileFormField.spFirstName,
                        ),
                        initialLastName: model.fieldValue(
                          EditProfileFormField.spLastName,
                        ),
                        onLastNameChanged: (lastName) =>
                            model.updateField<String>(
                          EditProfileFormField.spLastName,
                          value: lastName.trim(),
                        ),
                        lastNameErrorText: model.fieldValidationMessage(
                          EditProfileFormField.spLastName,
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField.phoneNumber(
                        initialText: model.fieldValue(
                          EditProfileFormField.spPhoneNumber,
                        ),
                        onChanged: (phoneNumber) => model.updateField<String>(
                          EditProfileFormField.spPhoneNumber,
                          value: phoneNumber.trim(),
                        ),
                        errorText: model.fieldValidationMessage(
                          EditProfileFormField.spPhoneNumber,
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField(
                        labelText: localization.occupation,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          EditProfileFormField.spOccupation,
                        ),
                        onChanged: (occupation) => model.updateField<String>(
                          EditProfileFormField.spOccupation,
                          value: occupation.trim(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        localization.otherInformation,
                        style: textTheme.headline3.copyWith(
                          fontSize: getResponsiveSmallFontSize(context),
                        ),
                      ),
                      SizedBox(height: 16),
                      AppTextField(
                        labelText: localization.address,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          EditProfileFormField.address,
                        ),
                        onChanged: (address) => model.updateField<String>(
                          EditProfileFormField.address,
                          value: address.trim(),
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField(
                        labelText: localization.zipCode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          EditProfileFormField.zipCode,
                        ),
                        errorText: model.fieldValidationMessage(
                          EditProfileFormField.zipCode,
                        ),
                        onChanged: (zipCode) => model.updateField<String>(
                          EditProfileFormField.zipCode,
                          value: zipCode.trim(),
                        ),
                      ),
                      SizedBox(height: 10),
                      AppTextField(
                        labelText: localization.licenseNumber,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          EditProfileFormField.licenseNumber,
                        ),
                        onChanged: (licenseNumber) => model.updateField<String>(
                          EditProfileFormField.licenseNumber,
                          value: licenseNumber.trim(),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        dropdownColor: theme.dialogBackgroundColor,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: localization.primaryLanguage,
                        ),
                        value: model
                                .fieldValue<String>(
                                  EditProfileFormField
                                      .primaryLanguage, // TODO match names
                                )
                                ?.toLowerCase() ??
                            "en-us",
                        onChanged: (languageCode) => model.updateField<String>(
                          EditProfileFormField.primaryLanguage,
                          value: languageCode.trim(),
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
                      /*Text(
                        "Logging Preference",
                        style: textTheme.headline3.copyWith(
                          fontSize: getResponsiveSmallFontSize(context),
                        ),
                      ),
                      SizedBox(height: 16),
                       DropdownButtonFormField<String>(
                        dropdownColor: theme.dialogBackgroundColor,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Logging Type",
                        ),
                        value: model
                                .fieldValue<String>(
                                  EditProfileFormField
                                      .loggingType, // TODO match names
                                )
                                ?.toLowerCase() ??
                            "daily",
                        onChanged: (logCode) => model.updateField<String>(
                          EditProfileFormField.loggingType,
                          value: logCode.trim(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: "daily",
                            child: Text(
                              "Daily Log",
                            ),
                          ),
                          DropdownMenuItem(
                            value: "weekly",
                            child: Text(
                              "Weekly Log",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),*/
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed:
                                model.submitting ? null : model.onSaveChanges,
                            child: model.submitting
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.dialogBackgroundColor,
                                    ),
                                  )
                                : Text(
                                    localization.saveChanges,
                                    style: textTheme.button,
                                  ),
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
