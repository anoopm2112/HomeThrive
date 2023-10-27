import 'package:fostershare/ui/common/forms/form_field_model_2.dart';

class FormModel<K, E> {
  final Map<K, FormFieldModel<Object, E>> _formFields =
      <K, FormFieldModel<Object, E>>{};

  FormFieldModel<T, E> field<T>(K key) {
    assert(_formFields.containsKey(key));

    return _formFields[key] as FormFieldModel<T, E>;
  }
}
