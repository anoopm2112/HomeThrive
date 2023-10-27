import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';

class FullNameTextFieldRow extends StatelessWidget {
  final String initialFirstName;
  final void Function(String) onFirstNameChanged;
  final String firstNameErrorText;
  final String initialLastName;
  final void Function(String) onLastNameChanged;
  final String lastNameErrorText;
  final String firstNameLabelText;
  final String lastNameLabelText;

  const FullNameTextFieldRow({
    Key key,
    this.initialFirstName,
    this.onFirstNameChanged,
    this.firstNameErrorText,
    this.initialLastName,
    this.onLastNameChanged,
    this.lastNameErrorText,
    this.firstNameLabelText,
    this.lastNameLabelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Row(
      children: [
        Flexible(
          child: AppTextField(
            labelText: firstNameLabelText ?? localization.firstName,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            initialText: this.initialFirstName,
            onChanged: this.onFirstNameChanged,
            errorText: this.firstNameErrorText,
          ),
        ),
        SizedBox(width: 20),
        Flexible(
          child: AppTextField(
            labelText: lastNameLabelText ?? localization.lastName,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            initialText: this.initialLastName,
            onChanged: this.onLastNameChanged,
            errorText: this.lastNameErrorText,
          ),
        ),
      ],
    );
  }
}
