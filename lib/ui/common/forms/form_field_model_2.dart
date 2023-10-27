class FormFieldModel<T, E> {
  final T value;
  final E validationError;
  final E Function(T) validator;

  FormFieldModel({
    this.value,
    this.validationError,
    this.validator,
  });

  FormFieldModel<T, E> validate() {
    return FormFieldModel<T, E>(
      value: this.value,
      validationError: this.validator?.call(this.value),
      validator: this.validator,
    );
  }

  FormFieldModel copyWith({
    T value,
    E validationMessage,
    String Function(T value) validator,
  }) {
    return FormFieldModel<T, E>(
      value: value ?? this.value,
      validationError: validationError ?? this.validationError,
      validator: validator ?? this.validator,
    );
  }

  @override
  String toString() {
    return "FormFieldModel(value: ${this.value}, validationError: ${this.validationError}, validator: ${this.validator})";
  }
}
