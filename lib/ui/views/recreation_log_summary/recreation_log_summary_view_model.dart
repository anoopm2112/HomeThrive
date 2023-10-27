import 'package:flutter/services.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/input/get_recreation_log_input/get_recreation_log_input.dart';
import 'package:fostershare/core/services/recreaction_log_services.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class RecreationLogSummaryViewModel extends BaseViewModel {
  RecreationLogSummaryViewModel(this.recLogId);

  final String recLogId;
  final _recLogService = locator<RecreationLogService>();
  final _toastService = locator<ToastService>();
  RecreationLog recreationLog;
  static final AppLocalizations _localization = AppLocalizations.current;

  Future<void> onModelReady() async {
    setBusy(true);
    await _loadRecreationLog();
    setBusy(false);
  }

  _loadRecreationLog() async {
    var result = await _recLogService.getSupportService(
      GetRecreationLogInput(recreationLogId: recLogId),
    );
    recreationLog = result;
  }
}
