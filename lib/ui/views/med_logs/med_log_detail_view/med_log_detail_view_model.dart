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
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/update_signing_status_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entries_input.dart';
import 'package:fostershare/core/models/response/get_med_log_entries_response/get_med_log_entries_response.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

enum MedLogDetailState { medicationDetail, medlogEntry }

class MedLogDetailViewModel extends BaseViewModel {
  final _medLogsService = locator<MedLogService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  final AppLocalizations localization;

  MedLogDetailState _state = MedLogDetailState.medicationDetail;
  MedLogDetailState get state => _state;
  List<MedLogMedicationDetail> medicationList;
  int get activeIndex => min(
        this._state.index,
        MedLogDetailState.values.length - 2,
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
  MedLogDetailViewModel({
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

    _state = MedLogDetailState.medicationDetail;

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
      _state = MedLogDetailState.medlogEntry;
      notifyListeners();
    }
  }

  void onBack() {
    _navigationService.back<MedLog>(result: this._medLog);
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

  onTapViewDocument() async {
    setBusy(true);
    var documentUrl =
        await _medLogsService.documentUrl(GetMedLogInput(_medLogId));
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
    setBusy(false);
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
