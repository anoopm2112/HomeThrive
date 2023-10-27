import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/create_secondary_parent_input/create_secondary_parent_input.dart';
import 'package:fostershare/core/models/input/update_profile_input/update_profile_input.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:fostershare/ui/common/validators.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart' show BaseViewModel;

enum FamilyRegistrationFormField {
  address,
  zipCode,
  license,
  languageCode,
}

class FamilyRegistrationViewModel extends BaseViewModel
    with FormViewModelMixin<FamilyRegistrationFormField> {
  final _bottomSheetService = locator<BottomSheetService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();
  static final AppLocalizations _localization = AppLocalizations.current;

  final String _submitting = "SigningInKey";
  bool get submitting => this.busy(this._submitting);

  Family _family;

  FamilyRegistrationViewModel({
    @required Family family,
  }) : this._family = family {
    this.addAllFormFields(
      {
        FamilyRegistrationFormField.address: FormFieldModel<String>(
          value: this._family.address,
        ),
        FamilyRegistrationFormField.zipCode: FormFieldModel<String>(
          value: this._family.zipCode,
          validator: (zipCode) => validUSZipCode(
            zipCode,
            optional: true,
          )
              ? null
              : _localization.enterValidZip,
        ),
        FamilyRegistrationFormField.license: FormFieldModel<String>(
          value: this._family.licenseNumber, // TODO validator
        ),
        FamilyRegistrationFormField.languageCode: FormFieldModel<String>(
          value: this._family.primaryLanguage,
        ),
      },
    );
  }

  void onBack() {
    _navigationService.back();
  }

  @override
  void updateField<T>(
    FamilyRegistrationFormField key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) {
    super.updateField<T>(
      key,
      value: value,
      validationMessage: validationMessage,
      validator: validator,
    );

    notifyListeners();
  }

  Future<void> onRegister() async {
    final bool validForm = this.validateForm();
    notifyListeners();
    if (validForm) {
      this.setBusyForObject(this._submitting, true);

      try {
        await _profileService.updateProfile(
          UpdateProfileInput(
            firstName: this._family.firstName,
            lastName: this._family.lastName,
            phoneNumber: this._family.phoneNumber,
            occupation: this._family.occupation,
            address: this.fieldValue<String>(
              FamilyRegistrationFormField.address,
            ),
            city: this._family.city,
            state: this._family.state,
            zipCode: this.fieldValue<String>(
              FamilyRegistrationFormField.zipCode,
            ),
            licenseNumber: this.fieldValue<String>(
              FamilyRegistrationFormField.license,
            ),
            primaryLanguage: this.fieldValue<String>(
              FamilyRegistrationFormField.languageCode,
            ),
            secondaryParents: this
                ._family
                .secondaryParents
                .map<CreateSecondaryParentInput>(
                  (parentContactInformation) =>
                      CreateSecondaryParentInput.fromParentContactInformation(
                    parentContactInformation,
                  ),
                )
                .toList(),
          ),
        );

        _bottomSheetService.successfulSignIn().then(
              (_) => this.setBusyForObject(
                this._submitting,
                false,
              ),
            );
      } catch (e) {
        print(e);
        // TODO
      }
    }
  }
}
