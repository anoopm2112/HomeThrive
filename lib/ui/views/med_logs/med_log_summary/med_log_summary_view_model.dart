import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/med_log/generate_signing_request_input.dart';
import 'package:fostershare/core/models/input/med_log/update_signing_status_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entries_input.dart';
import 'package:fostershare/core/models/response/get_med_log_entries_response/get_med_log_entries_response.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/views/home/auth/auth_home_view_model.dart';
import 'package:stacked/stacked.dart';

enum MedLogInputState {
  viewAllMedication,
  medicationDetail,
  medlogEntry,
  signingView,
  medlogComplete
}

class MedLogSummaryViewModel extends BaseViewModel {
  final _medLogsService = locator<MedLogService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  final AppLocalizations localization;
  final String _submitting = "SigningInKey";
  bool get submitting => this.busy(this._submitting);

  MedLogInputState _state = MedLogInputState.viewAllMedication;
  MedLogInputState get state => _state;
  List<MedLogMedicationDetail> medicationList;
  int get activeIndex => min(
        this._state.index,
        MedLogInputState.values.length - 2,
      );
  MedLog _medLog;
  MedLog get medLog => _medLog;
  DateTime _date;
  DateTime get logdate => _date;
  Child _child;
  Child get child => _child;
  String _medLogId;
  int _limit = 100;
  GetMedLogEntriesResponse _getMedLogEntriesResponse;
  int get totalCount => _getMedLogEntriesResponse.pageInfo.count;

  //List<MedLogEntry> entries = [];
  String finalUrl = 'https://www.fostershare.org/';
  String _url;
  String get signingUrl => _url;

  MedLogEntry _selectedMedlogentry;
  MedLogEntry get selectedMedlogentry => _selectedMedlogentry;
  final Map<String, List<MedLogEntry>> entries = <String, List<MedLogEntry>>{};
  List entryKeys = [];
  MedLogSummaryViewModel({
    @required this.localization,
    @required MedLog medLog,
    void Function(MedLog medLog) onComplete,
  })  : this._date = medLog.year != null
            ? DateTime(medLog.year, medLog.month).toUtc()
            : null,
        this._child = medLog.child,
        this._medLog = medLog,
        this._medLogId = medLog?.id {
    // final String logStorageKey = childLogStorageKey(
    //   child: this._child,
    //   date: this._date,
    // );
    _loadMedLogEntries();
  }

  Future _loadMedLogEntries() async {
    this.setBusy(true);
    try {
      _getMedLogEntriesResponse = await _medLogsService.medLogEntries(
        GetMedLogEntriesInput(
          _medLogId,
          CursorPaginationInput(
            limit: _limit,
            cursor: _getMedLogEntriesResponse?.pageInfo?.cursor,
          ),
        ),
      );
    } catch (err) {
      print(err); //TODO: Handle error
    }
    _getMedLogEntriesResponse.items.forEach(
      (entry) {
        _insertEntry(entry);
      },
    );
    //entries.addAll(_getMedLogEntriesResponse.items);
    notifyListeners();
    this.setBusy(false);
  }

  void onPrevious() {
    // TODO made it programtic you can't mess up

    _state = MedLogInputState.viewAllMedication;

    notifyListeners();
  }

  backFromWeb() async {
    setBusy(true);

    // if (medLog.signingStatus != SigningStatus.COMPLETED) {
    //   await _medLogsService.updateSigningStatus(
    //       UpdateSigningStatusInput(medLog.id, SigningStatus.DRAFT));
    // }

    setBusy(false);
    _medLog.signingStatus = SigningStatus.COMPLETED;
    _state = MedLogInputState.medlogComplete;

    notifyListeners();
  }

  void onTapSign() async {
    setBusy(true);
    try {
      _url = await _medLogsService
          .signingUrl(GenerateSigningRequestInput(_medLogId));
    } catch (err) {
      _toastService.displayToast("Unable to retrieve URL for signing");
    }
    /*await _navigationService.navigateTo(
      Routes.signingView,
      arguments: SigningViewArguments(
          signingUrl: url,
          finalUrl: 'https://www.fostershare.org/',
          medLogId: _medLogId),
    );*/
    if (_url != "" && _url != null) _state = MedLogInputState.signingView;
    setBusy(false);
    notifyListeners();
  }

  onTapSubmit() async {
    setBusy(true);
    try {
      await _medLogsService.submitAndGenerateSigningRequest(
          GenerateSigningRequestInput(_medLogId));
    } catch (err) {
      setBusy(false);
      _toastService.displayToast(localization.unableToSubmit);
      return;
    }
    _medLog.isSubmitted = true;
    _medLog.canSign = true;
    _medLog.signingStatus = SigningStatus.SENT;
    setBusy(false);
    _toastService.displayToast(localization.submitMontlyMedLog);
    notifyListeners();
  }

  Future<void> viewMedLogEntry(MedLogEntry medlogentry) async {
    if (medlogentry != null) {
      _selectedMedlogentry = medlogentry;
      _state = MedLogInputState.medlogEntry;
      notifyListeners();
    }
  }

  void onBack() {
    var date = DateTime(this._medLog.year, this._medLog.month, 1);
    var homeClass = new AuthHomeViewModel();
    homeClass.onPageChanged(date);
    _navigationService.back<MedLog>(result: this._medLog);
    notifyListeners();
  }

  String getFailureReasonString(FailureReason reason) {
    switch (reason) {
      case FailureReason.Refused:
        return localization.childRefused;
        break;
      case FailureReason.Missed:
        return localization.missedWindow;
        break;
      case FailureReason.Error:
        return localization.other;
        break;
    }
  }

  bool get canSubmit {
    var current = DateTime.now();
    var lastDayOfMedLogMonth = DateTime(medLog.year, medLog.month + 1, 0);
    if (current.year == lastDayOfMedLogMonth.year &&
        current.month == lastDayOfMedLogMonth.month &&
        current.day == lastDayOfMedLogMonth.day) {
      return true;
    } else if (current.year > medLog.year) {
      return true;
    } else if (current.year == medLog.year && current.month > medLog.month) {
      return true;
    }
    return false;
  }

  void _insertEntry(MedLogEntry medLogEntry) {
    var date = DateTime(medLogEntry.dateTime.year, medLogEntry.dateTime.month,
        medLogEntry.dateTime.day);
    final String medLogKey = date.toLocal().toString();
    if (entries.containsKey(medLogKey)) {
      entries[medLogKey].add(medLogEntry);
    } else {
      entries[medLogKey] = <MedLogEntry>[medLogEntry];
    }
    if (entryKeys.where((element) => element == medLogKey).isEmpty)
      entryKeys.add(medLogKey);
  }
}
