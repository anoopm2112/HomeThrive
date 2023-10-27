import 'package:collection/collection.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/create_secondary_parent_input/create_secondary_parent_input.dart';
import 'package:fostershare/core/models/input/update_profile_input/update_profile_input.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:fostershare/ui/common/validators.dart';
import 'package:stacked/stacked.dart';

enum EditProfileFormField {
  ppFirstName,
  ppLastName,
  ppPhoneNumber,
  ppOccupation,
  spId,
  spEmail,
  spFirstName,
  spLastName,
  spPhoneNumber,
  spOccupation,
  address,
  zipCode,
  licenseNumber,
  primaryLanguage,
  loggingType,
}

class EditProfileViewModel extends BaseViewModel
    with FormViewModelMixin<EditProfileFormField> {
  final _loggerService = locator<LoggerService>();
  final _profileService = locator<ProfileService>();
  final _toastService = locator<ToastService>();
  final _localization = AppLocalizations.current;

  final String _submitting = "SigningInKey";
  bool get submitting => this.busy(this._submitting);

  Family _family;

  CreateSecondaryParentInput get _enteredSecondaryParent =>
      CreateSecondaryParentInput(
          // TODO make util
          this.fieldValue(
            EditProfileFormField.spId,
          ),
          email: this.fieldValue(
            EditProfileFormField.spEmail,
          ),
          firstName: this.fieldValue(
            EditProfileFormField.spFirstName,
          ),
          lastName: this.fieldValue(
            EditProfileFormField.spLastName,
          ),
          occupation: this.fieldValue(
            EditProfileFormField.spOccupation,
          ),
          phoneNumber: this.fieldValue<String>(
                        EditProfileFormField.spPhoneNumber,
                      ) ==
                      null ||
                  this
                      .fieldValue<String>(
                        EditProfileFormField.spPhoneNumber,
                      )
                      .isEmpty
              ? null
              : "+${this.fieldValue<String>(
                  EditProfileFormField.spPhoneNumber,
                )}");

  bool get _secondaryParentEntered =>
      _notEmpty(_enteredSecondaryParent.firstName) ||
      _notEmpty(_enteredSecondaryParent.lastName) ||
      _notEmpty(_enteredSecondaryParent.occupation) ||
      _notEmpty(_enteredSecondaryParent.phoneNumber);

  Future<void> onModelReady() async {
    this.setBusy(true);

    try {
      this._family = await _profileService.family();

      this.addAllFormFields(
        {
          EditProfileFormField.ppFirstName: FormFieldModel<String>(
            value: this._family.firstName,
            validator: (firstName) => firstName != null && firstName.isNotEmpty
                ? null
                : _localization.enterFirstName, // TODO
          ),
          EditProfileFormField.ppLastName: FormFieldModel<String>(
            value: this._family.lastName,
            validator: (lastName) => // TODO give access to field?
                lastName != null && lastName.isNotEmpty
                    ? null
                    : _localization.enterLastName, // TODO validator
          ),
          EditProfileFormField.ppPhoneNumber: FormFieldModel<String>(
            value: this._family.phoneNumber?.replaceAll(RegExp(r'[^0-9]'), ''),
            validator: _phoneNumberValidator,
          ),
          EditProfileFormField.ppOccupation: FormFieldModel<String>(
            value: this._family.occupation,
          ),
          EditProfileFormField.spId: FormFieldModel<String>(
            value: this._family.secondaryParents?.firstOrNull?.id,
          ),
          EditProfileFormField.spEmail: FormFieldModel<String>(
            value: this._family.secondaryParents?.firstOrNull?.email,
          ),
          EditProfileFormField.spFirstName: FormFieldModel<String>(
            value: this._family.secondaryParents?.firstOrNull?.firstName,
            validator: (firstName) => !this._secondaryParentEntered
                ? null
                : firstName != null && firstName.isNotEmpty
                    ? null
                    : _localization.enterFirstName, // TODO move to  enum
          ),
          EditProfileFormField.spLastName: FormFieldModel<String>(
            value: this._family.secondaryParents?.firstOrNull?.lastName,
            validator: (lastName) => !this._secondaryParentEntered
                ? null
                : lastName != null && lastName.isNotEmpty
                    ? null
                    : _localization.enterLastName,
          ),
          EditProfileFormField.spPhoneNumber: FormFieldModel<String>(
            value: this
                ._family
                .secondaryParents
                ?.firstOrNull
                ?.phoneNumber
                ?.replaceAll(RegExp(r'[^0-9]'), ''),
            validator: (phoneNumber) =>
                phoneNumber == null || phoneNumber.isEmpty
                    ? null
                    : _phoneNumberValidator(phoneNumber),
          ),
          EditProfileFormField.spOccupation: FormFieldModel<String>(
              value: this._family.secondaryParents?.firstOrNull?.occupation),
          EditProfileFormField.address: FormFieldModel(
            value: this._family.address,
          ),
          EditProfileFormField.zipCode: FormFieldModel<String>(
            value: this._family.zipCode,
            validator: (zipCode) => validUSZipCode(
              zipCode,
              optional: true,
            )
                ? null
                : _localization.enterValidZip,
          ),
          EditProfileFormField.licenseNumber: FormFieldModel(
            value: this._family.licenseNumber,
          ),
          EditProfileFormField.primaryLanguage: FormFieldModel(
            value: this._family.primaryLanguage,
          ),
          EditProfileFormField.loggingType: FormFieldModel(
            value: this._family.isWeekly == true ? "weekly" : "daily",
          ),
        },
      );

      this.setBusy(false);
    } catch (e, s) {
      _loggerService.error("Error", error: e, stackTrace: s);
      // TODO error
    }
  }

  bool _notEmpty(String field) {
    return field != null && field.isNotEmpty;
  }

  Future<void> onSaveChanges() async {
    final bool validForm = this.validateForm();
    notifyListeners();

    if (validForm) {
      this.setBusyForObject(this._submitting, true);

      try {
        await _profileService.updateProfile(
          UpdateProfileInput(
            firstName: this.fieldValue(
              EditProfileFormField.ppFirstName,
            ),
            lastName: this.fieldValue(
              EditProfileFormField.ppLastName,
            ),
            phoneNumber: "+${this.fieldValue(
              EditProfileFormField.ppPhoneNumber,
            )}",
            occupation: this.fieldValue(
              EditProfileFormField.ppOccupation,
            ),
            address: this.fieldValue(
              EditProfileFormField.address,
            ),
            city: this._family.city,
            state: this._family.state,
            zipCode: this.fieldValue(
              EditProfileFormField.zipCode,
            ),
            licenseNumber: this.fieldValue(
              EditProfileFormField.licenseNumber,
            ),
            primaryLanguage: this.fieldValue(
              EditProfileFormField.primaryLanguage,
            ),
            // isWeekly: this.fieldValue(
            //           EditProfileFormField.loggingType,
            //         ) ==
            //         "weekly"
            //     ? true
            //     : false,
            secondaryParents: [
              if (this._secondaryParentEntered) _enteredSecondaryParent
            ],
          ),
        );

        _toastService.profileUpdated(
          () => this.setBusyForObject(this._submitting, false),
        );
      } catch (e) {
        _toastService.profileUpdateError(
          () => this.setBusyForObject(this._submitting, false),
        );
      }
    }
  }

  String _phoneNumberValidator(String value) {
    Pattern pattern = r"[0-9]{11}$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return _localization.enterPhoneNumber;
    else
      return null;
  }
}
