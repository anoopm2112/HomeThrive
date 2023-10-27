bool validUSZipCode(String usZipCode, {bool optional = false}) {
  assert(optional != null);

  final RegExp _postalCodeRegex = RegExp(r"^\d{5}(-\d{4})?$");
  return optional && (usZipCode == null || usZipCode.isEmpty)
      ? true
      : usZipCode == null || !_postalCodeRegex.hasMatch(usZipCode)
          ? false
          : true;
}
