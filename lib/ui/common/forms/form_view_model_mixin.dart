import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:meta/meta.dart';

mixin FormViewModelMixin<K> {
  final _formFields = <K, FormFieldModel>{};

  void addAllFormFields(Map<K, FormFieldModel> formFields) {
    assert(formFields != null);

    this._formFields.addAll(formFields);
  }

  T fieldValue<T>(K key) {
    assert(_formFields.containsKey(key));

    return _formFields[key].value as T;
  }

  FormFieldModel<T> field<T>(K key) {
    assert(_formFields.containsKey(key));

    return _formFields[key] as FormFieldModel<T>;
  }

  void updateField<T>(
    K key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) {
    // TODO do better
    assert(_formFields.containsKey(key));

    _formFields[key] = _formFields[key].copyWith<T>(
      value: value,
      validationMessage: validationMessage,
      validator: validator,
    );
  }

  String fieldValidationMessage(K key) {
    assert(_formFields.containsKey(key));

    return _formFields[key].validationMessage;
  }

  void onFieldChanged({
    @required K key,
    @required String value,
  }) {
    assert(key != null);
    assert(value != null);

    if (_formFields.containsKey(key)) {
      _formFields[key] = _formFields[key].copyWith(value: value);
    } else {
      _formFields[key] = FormFieldModel(value: value);
    }
  }

  bool validateForm() {
    bool valid = true;

    _formFields.updateAll((key, value) {
      final FormFieldModel updatedFormFieldModel = value.validate();
      if (!updatedFormFieldModel.valid) {
        valid = false;
      }
      return updatedFormFieldModel;
    });

    return valid;
  }

  bool validateField(K key) {
    assert(_formFields.containsKey(key));

    _formFields[key] = _formFields[key].validate();
    return _formFields[key].valid;
  }
}
