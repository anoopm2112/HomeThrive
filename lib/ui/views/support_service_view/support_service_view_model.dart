import 'package:flutter/services.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/support_service/support_service.dart';
import 'package:fostershare/core/models/input/get_support_service_input/get_support_service_input.dart';
import 'package:fostershare/core/services/support_service_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportServiceViewModel extends BaseViewModel {
  SupportServiceViewModel(this.supportServiceId);

  final String supportServiceId;
  final _supportServiceService = locator<SupportServiceService>();
  final _toastService = locator<ToastService>();
  SupportService supportService;
  static final AppLocalizations _localization = AppLocalizations.current;

  Future<void> onModelReady() async {
    setBusy(true);
    await _loadSupportService();
    setBusy(false);
  }

  Future<void> onWebsiteTap(String url) async {
    var err = _localization.unableToLaunchWebsite;
    if (!url.startsWith('http')) {
      url = 'http://$url';
    }
    if (await canLaunch(url)) {
      launch(url);
    } else {
      _toastService.displayToast(err);
    }
  }

  Future<void> onEmailTap(String url) async {
    var emailUrl = 'mailto:$url';
    var err = _localization.unableToSendEmail;
    if (await canLaunch(emailUrl)) {
      launch(emailUrl);
    } else {
      _toastService.displayToast(err);
    }
  }

  Future<void> onSmsTap(String phoneNumber) async {
    var phoneUrl = 'sms:$phoneNumber';
    var err = _localization.unableToSendSms;
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
    } else {
      _toastService.displayToast(err);
    }
  }

  Future<void> onCallTap(String phoneNumber) async {
    var phoneUrl = 'tel:$phoneNumber';
    var err = _localization.unableToMakePhoneCall;
    if (await canLaunch(phoneUrl)) {
      launch(phoneUrl);
    } else {
      _toastService.displayToast(err);
    }
  }

  Future<void> onLongPressWebsite(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    _toastService.displayToast(_localization.websiteCopied);
  }

  Future<void> onLongPressPhone(String phoneNumber) async {
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    _toastService.displayToast(_localization.phoneNumberCopied);
  }

  Future<void> onLongPressEmail(String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    _toastService.displayToast(_localization.emailCopied);
  }

  _loadSupportService() async {
    var result = await _supportServiceService.getSupportService(
      GetSupportServiceInput(id: supportServiceId),
    );
    supportService = result;
  }
}
