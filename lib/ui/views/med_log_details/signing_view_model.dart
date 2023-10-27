import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/update_signing_status_input.dart';

class SigningViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _medLogsService = locator<MedLogService>();
  final String medLogId;
  MedLog medLog;

  SigningViewModel(this.medLogId);
  onTapBack() async {
    setBusy(true);
    medLog = await _medLogsService.medLog(GetMedLogInput(medLogId));
    if (medLog.signingStatus != SigningStatus.COMPLETED) {
      await _medLogsService.updateSigningStatus(
          UpdateSigningStatusInput(medLogId, SigningStatus.DRAFT));
    }
    _navigationService.back();
    setBusy(false);
    //return true;
  }
}
