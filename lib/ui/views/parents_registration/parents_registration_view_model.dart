import 'package:collection/collection.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/create_secondary_parent_input/create_secondary_parent_input.dart';
import 'package:fostershare/core/models/input/update_profile_input/update_profile_input.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum ParentsRegisterFormField {
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
}

class ParentsRegistrationViewModel extends BaseViewModel
    with FormViewModelMixin<ParentsRegisterFormField> {
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();
  final _localization = AppLocalizations.current;

  final String _submitting = "SubmittingKey";
  bool get submitting => this.busy(this._submitting);

  Family _family;
  // Family get _family => _profileService.family;

// TODO don't repeat these forms
  CreateSecondaryParentInput get _enteredSecondaryParent =>
      CreateSecondaryParentInput(
          // TODO make util
          this.fieldValue(
            ParentsRegisterFormField.spId,
          ),
          email: this.fieldValue(
            ParentsRegisterFormField.spEmail,
          ),
          firstName: this.fieldValue(
            ParentsRegisterFormField.spFirstName,
          ),
          lastName: this.fieldValue(
            ParentsRegisterFormField.spLastName,
          ),
          occupation: this.fieldValue(
            ParentsRegisterFormField.spOccupation,
          ),
          phoneNumber: this.fieldValue<String>(
                        ParentsRegisterFormField.spPhoneNumber,
                      ) ==
                      null ||
                  this
                      .fieldValue<String>(
                        ParentsRegisterFormField.spPhoneNumber,
                      )
                      .isEmpty
              ? null
              : "+${this.fieldValue<String>(
                  ParentsRegisterFormField.spPhoneNumber,
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
          ParentsRegisterFormField.ppFirstName: FormFieldModel(
            value: this._family.firstName,
            validator: (firstName) => firstName != null && firstName.isNotEmpty
                ? null
                : _localization.enterFirstName, // TODO
          ),
          ParentsRegisterFormField.ppLastName: FormFieldModel<String>(
            value: this._family.lastName,
            validator: (lastName) => // TODO give access to field?
                lastName != null && lastName.trim().isNotEmpty
                    ? null
                    : _localization.enterLastName, // TODO validator
          ),
          ParentsRegisterFormField.ppPhoneNumber: FormFieldModel<String>(
            value: this._family.phoneNumber?.replaceAll(RegExp(r'[^0-9]'), ''),
            validator: _phoneNumberValidator,
          ),
          ParentsRegisterFormField.ppOccupation: FormFieldModel(
            value: this._family.occupation,
          ),
          ParentsRegisterFormField.spId: FormFieldModel(
            value: this._family?.secondaryParents?.firstOrNull?.id,
          ),
          ParentsRegisterFormField.spEmail: FormFieldModel(
            value: this._family?.secondaryParents?.firstOrNull?.email,
          ),
          ParentsRegisterFormField.spFirstName: FormFieldModel(
            value: this._family.secondaryParents?.firstOrNull?.firstName,
            validator: (firstName) => !this._secondaryParentEntered
                ? null
                : firstName != null && firstName.isNotEmpty
                    ? null
                    : _localization.enterFirstName, // TODO
          ),
          ParentsRegisterFormField.spLastName: FormFieldModel(
            value: this._family.secondaryParents?.firstOrNull?.lastName,
            validator: (lastName) => !this._secondaryParentEntered
                ? null
                : lastName != null && lastName.isNotEmpty
                    ? null
                    : _localization.enterLastName, // TODO validator
          ),
          ParentsRegisterFormField.spPhoneNumber: FormFieldModel<String>(
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
          ParentsRegisterFormField.spOccupation: FormFieldModel(
            value: this._family.secondaryParents?.firstOrNull?.occupation,
          ),
        },
      );
    } catch (e) {
      // TODO
    }

    this.setBusy(false);
  }

  bool _notEmpty(String field) {
    return field != null && field.isNotEmpty;
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }

  Future<void> onContinue() async {
    final bool validForm = this.validateForm();
    notifyListeners();

    if (validForm) {
      this.setBusyForObject(_submitting, true);

      try {
        print("+${this.fieldValue<String>(
          ParentsRegisterFormField.ppPhoneNumber,
        )}");
        print("+${this.fieldValue(
          ParentsRegisterFormField.spPhoneNumber,
        )}");
        final Family family = await _profileService.updateProfile(
          UpdateProfileInput(
            firstName: this.fieldValue<String>(
              ParentsRegisterFormField.ppFirstName,
            ),
            lastName: this.fieldValue<String>(
              ParentsRegisterFormField.ppLastName,
            ),
            phoneNumber: "+${this.fieldValue<String>(
              ParentsRegisterFormField.ppPhoneNumber,
            )}",
            occupation: this.fieldValue<String>(
              ParentsRegisterFormField.ppOccupation,
            ),
            address: this._family.address,
            city: this._family.city,
            state: this._family.state,
            zipCode: this._family.zipCode,
            licenseNumber: this._family.licenseNumber,
            primaryLanguage: this._family.primaryLanguage,
            secondaryParents: [
              if (this._secondaryParentEntered) _enteredSecondaryParent
            ],
          ),
        );

        _navigationService
            .navigateTo(
              Routes.familyRegistrationView,
              arguments: FamilyRegistrationViewArguments(
                family: family,
              ),
            )
            .then(
              (_) => this.setBusyForObject(
                _submitting,
                false,
              ),
            );
      } catch (e, s) {
        _loggerService.error(
          "ParentsRegistrationViewModel | onContinue() - Could not update profile",
          error: e,
          stackTrace: s,
        );

        // TODO set error
        this.setBusyForObject(_submitting, true);
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
