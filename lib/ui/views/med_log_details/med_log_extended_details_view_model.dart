import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/med_log/generate_signing_request_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entries_input.dart';
import 'package:fostershare/core/models/response/get_med_log_entries_response/get_med_log_entries_response.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_log_details/create_medication_view.dart';
import 'package:fostershare/ui/views/med_log_details/create_medlog_note_view.dart';
import 'package:fostershare/ui/views/med_log_details/signing_view.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_medlog_entry_view.dart';

class MedLogExtendedDetailsViewModel extends BaseViewModel {
  final _medLogsService = locator<MedLogService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  MedLog medLog;
  final medLogId;

  MedLogExtendedDetailsViewModel(this.medLogId);

  Future<void> onModelReady() async {
    setBusy(true);
    await Future.wait([
      _loadMedLog(),
    ]);
    setBusy(false);
  }

  onTapViewDocument() async {
    var documentUrl =
        await _medLogsService.documentUrl(GetMedLogInput(medLogId));
    if (await canLaunch(documentUrl)) {
      try {
        launch(
          documentUrl,
        );
      } catch (err) {
        _toastService.displayToast('Could not open document');
      }
    } else {
      _toastService.displayToast('Could not open document');
    }
  }

  Future _loadMedLog() async {
    try {
      medLog = await _medLogsService.medLog(GetMedLogInput(medLogId),
          isExtended: true);
    } catch (err) {
      _toastService.displayToast("Unable to load");
    }
    notifyListeners();
  }
}
