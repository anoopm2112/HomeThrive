class FormFieldModel<T> {
  final T value;
  final String validationMessage;
  bool get valid => validationMessage == null;
  final String Function(T) validator;

  FormFieldModel({
    this.value,
    this.validationMessage,
    this.validator,
  });

  FormFieldModel<T> validate() {
    return FormFieldModel<T>(
      value: this.value,
      validationMessage: this.validator?.call(this.value),
      validator: this.validator,
    );
  }

  FormFieldModel<M> copyWith<M>({
    M value,
    String validationMessage,
    String Function(M value) validator,
  }) {
    return FormFieldModel<M>(
      value: value ?? this.value,
      validationMessage: validationMessage ?? this.validationMessage,
      validator: validator ?? this.validator,
    );
  }

  @override
  String toString() {
    return "FormFieldModel(value: ${this.value}, error: ${this.validationMessage}, validator: ${this.validator})";
  }
}
