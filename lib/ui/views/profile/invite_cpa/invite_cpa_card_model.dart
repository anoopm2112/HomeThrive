import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/input/invitiation_input/invitiation_input.dart';
import 'package:fostershare/core/services/graphql/guest/guest_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:graphql/client.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:stacked/stacked.dart';

class InviteCpaCardModel extends BaseViewModel {
  final _guestGraphQLService = locator<GuestGraphQLService>();
  final _loggerService = locator<LoggerService>();
  final _toastService = locator<ToastService>();
  final _localization = AppLocalizations.current;

  bool _sendingInvite = false;
  bool get sendingInvite => _sendingInvite;

  TextEditingController _emailController;

  String _email;
  bool get _validEmail =>
      this._email != null &&
      EmailValidator.validate(this._email); // TODO move to helper
  String _emailErrorText;
  String get emailErrorText => _emailErrorText;

  void onModelReady(TextEditingController emailController) {
    this._emailController = emailController;
  }

  void onEmailChanged(String newEmail) {
    this._email = newEmail.trim();
  }

  void _setSendingInvite(bool newSendingInvite) {
    assert(newSendingInvite != null);

    this._sendingInvite = newSendingInvite;
    notifyListeners();
  }

  void _handleEmailErrors() {
    this._emailErrorText = null;
    if (!this._validEmail) {
      this._emailErrorText = _localization.invalidEmail;
    }

    notifyListeners();
  }

  void _clearForm(void Function() onDismiss) {
    this._email = null;
    this._emailErrorText = null;
    _emailController.clear();
    onDismiss();
  }

  Future<void> onSend(void Function() onDismiss) async {
    _handleEmailErrors();
    if (this._validEmail) {
      try {
        _setSendingInvite(true);

        final QueryResult result = await _guestGraphQLService.sendInvitation(
          InvitiationInput(email: this._email),
        );

        final bool success = result.data["sendInvitation"]["success"];
        if (success) {
          _setSendingInvite(false);
          _toastService.test(() => _clearForm(onDismiss)); // TODO clear

        } else {
          throw Exception("Sending invitation was not successful");
        }
      } catch (e, s) {
        // TODO general error
        _setSendingInvite(false);
        _toastService.sendInvitiation(() {}); // TODO clear
        _loggerService.error(
          "InviteCpaCardModel - General Exception - Could not invite cpa tto join platform",
          error: e,
          stackTrace: s,
        );
      }
    }
  }
}
