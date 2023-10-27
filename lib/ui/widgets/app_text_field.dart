import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppTextField extends StatefulWidget {
  final FocusNode focusNode;
  final bool autoFocus;
  final EdgeInsets scrollPadding;
  final TextEditingController controller;
  final String initialText;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String labelText;
  final String errorText;
  final Widget suffixIcon;
  final bool obscureText;
  final String obscuringCharacter;
  final EdgeInsets contentPadding;
  final EdgeInsets errorContainerPadding;
  final Decoration errorContainerDecoration;

  const AppTextField({
    Key key,
    this.focusNode,
    this.autoFocus = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.controller,
    this.initialText,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.floatingLabelBehavior,
    this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = false,
    this.obscuringCharacter = "*",
    this.contentPadding,
    this.errorContainerPadding = const EdgeInsets.only(bottom: 8),
    this.errorContainerDecoration = const BoxDecoration(
      color: AppColors.orange500,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  })  : assert(scrollPadding != null),
        assert(textCapitalization != null),
        assert(obscureText != null),
        super(key: key);

  factory AppTextField.phoneNumber({
    String initialText,
    void Function(String) onChanged,
    String errorText,
  }) {
    return _PhoneNumberTextField(
      initialText: initialText,
      onChanged: onChanged,
      errorText: errorText,
    );
  }

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = this.widget.controller ??
        TextEditingController(
          text: this.widget.initialText,
        );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final bool error = widget.errorText != null;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: error ? this.widget.errorContainerPadding : EdgeInsets.zero,
      decoration:
          error ? this.widget.errorContainerDecoration : BoxDecoration(),
      child: TextField(
        scrollPadding: this.widget.scrollPadding,
        focusNode: this.widget.focusNode,
        autofocus: this.widget.autoFocus,
        controller: this._controller,
        onChanged: this.widget.onChanged,
        keyboardType: this.widget.keyboardType,
        textInputAction: this.widget.textInputAction,
        minLines: this.widget.minLines,
        maxLines: this.widget.maxLines,
        inputFormatters: this.widget.inputFormatters,
        textCapitalization: this.widget.textCapitalization,
        decoration: InputDecoration(
          floatingLabelBehavior: this.widget.floatingLabelBehavior,
          alignLabelWithHint: true,
          labelText: this.widget.labelText,
          labelStyle: inputDecorationTheme.labelStyle.copyWith(
            color: error ? inputDecorationTheme.focusColor : null,
          ),
          errorText: this.widget.errorText,
          suffixIcon: this.widget.suffixIcon,
          contentPadding: this.widget.contentPadding,
        ),
        obscureText: this.widget.obscureText,
        obscuringCharacter: this.widget.obscuringCharacter,
      ),
    );
  }
}

class _PhoneNumberTextField extends AppTextField {
  const _PhoneNumberTextField({
    String initialText,
    void Function(String) onChanged,
    String errorText,
  }) : super(
          initialText: initialText,
          onChanged: onChanged,
          errorText: errorText,
        );

  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends _AppTextFieldState {
  MaskTextInputFormatter _phoneNumberMaskFormatter;

  @override
  void initState() {
    super.initState();
    _phoneNumberMaskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: this.widget.initialText,
    );

    this._controller.text = this._phoneNumberMaskFormatter.getMaskedText();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return AppTextField(
      controller: this._controller,
      labelText: localization.phoneNumber, // TODO
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onChanged: (_) => this.widget.onChanged?.call(
            _phoneNumberMaskFormatter.getUnmaskedText(),
          ),
      errorText: this.widget.errorText,
      inputFormatters: [
        _phoneNumberMaskFormatter,
      ],
    );
  }
}
