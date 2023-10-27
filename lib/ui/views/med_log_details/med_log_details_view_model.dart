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

import 'create_medlog_entry_view.dart';

class MedLogDetailsViewModel extends BaseViewModel {
  final _medLogsService = locator<MedLogService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  MedLog medLog;
  final medLogId;

  int _limit = 10;
  GetMedLogEntriesResponse _getMedLogEntriesResponse;
  int get totalCount => _getMedLogEntriesResponse.pageInfo.count;
  bool _loading = false;
  List<MedLogEntry> entries = [];
  bool isLoadingComplete = false;
  bool isSigned = false;

  MedLogDetailsViewModel(this.medLogId);

  Future<void> onModelReady() async {
    setBusy(true);
    await Future.wait([
      _loadMedLog(),
      _loadMedLogEntries(),
    ]);
    setBusy(false);
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

  onTapSubmit() async {
    setBusy(true);
    try {
      await _medLogsService.submitAndGenerateSigningRequest(
          GenerateSigningRequestInput(medLogId));
    } catch (err) {
      setBusy(false);
      _toastService.displayToast("Unable to submit");
      return;
    }
    medLog.isSubmitted = true;
    medLog.signingStatus = SigningStatus.SENT;
    setBusy(false);
    _toastService.displayToast("Submitted");
    await _loadMedLog();
  }

  onTapSign() async {
    setBusy(true);
    String url;
    try {
      url = await _medLogsService
          .signingUrl(GenerateSigningRequestInput(medLogId));
    } catch (err) {
      _toastService.displayToast("Unable to retrieve URL for signing");
    }
    await _navigationService.navigateTo(
      Routes.signingView,
      arguments: SigningViewArguments(
          signingUrl: url,
          finalUrl: 'https://www.fostershare.org/',
          medLogId: medLogId),
    );
    await _loadMedLog();
    setBusy(false);
  }

  onTapAddEntry(MedLogMedicationDetail medication) async {
    var entry = await showModalBottomSheet<MedLogEntry>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: CreateMedLogEntryView(
          medLogId,
          medLog.year,
          medLog.month,
          medication.id,
        ),
      ),
    );
    if (entry != null) {
      entries.insert(0, entry);
    }
    notifyListeners();
  }

  Future _loadMedLog() async {
    medLog = await _medLogsService.medLog(GetMedLogInput(medLogId));
    notifyListeners();
  }

  onTapMoreDetails() {
    _navigationService.navigateTo(Routes.medLogExtendedDetailsView,
        arguments: MedLogExtendedDetailsViewArguments(medLogId: medLogId));
  }

  onTileCreated(int index) async {
    if (_getMedLogEntriesResponse?.pageInfo?.hasNextPage != null &&
        !_getMedLogEntriesResponse.pageInfo.hasNextPage) {
      return;
    }
    if (_loading) {
      return;
    }
    await _loadMedLogEntries();
  }

  onTapCreateMedicationNote(MedLogMedicationDetail medication) async {
    var notesCount = await showModalBottomSheet<int>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: CreateMedLogNoteView(medLogId, medicationId: medication.id),
      ),
    );
    if (notesCount != null) {
      medication.notesCount = notesCount;
    }
    notifyListeners();
  }

  onTapCreateEntryNote(MedLogEntry entry) async {
    var notesCount = await showModalBottomSheet<int>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: CreateMedLogNoteView(medLogId, medLogEntryId: entry.id),
      ),
    );
    if (notesCount != null) {
      entry.notesCount = notesCount;
    }
    notifyListeners();
  }

  deleteEntry(String entryId) async {
    setBusy(true);
    await _medLogsService.deleteMedLogEntry(entryId);
    entries.removeWhere((element) => element.id == entryId);
    setBusy(false);
  }

  onTapCreateMedication() async {
    var medications = await showModalBottomSheet<List<MedLogMedicationDetail>>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: CreateMedicationView(medLogId),
      ),
    );
    if (medications != null) {
      medLog.medications = medications;
    }
    notifyListeners();
  }

  Future _loadMedLogEntries() async {
    _loading = true;
    try {
      _getMedLogEntriesResponse = await _medLogsService.medLogEntries(
        GetMedLogEntriesInput(
          medLogId,
          CursorPaginationInput(
            limit: _limit,
            cursor: _getMedLogEntriesResponse?.pageInfo?.cursor,
          ),
        ),
      );
    } catch (err) {
      print(err); //TODO: Handle error
    }
    entries.addAll(_getMedLogEntriesResponse.items);
    notifyListeners();
    isLoadingComplete = !_getMedLogEntriesResponse.pageInfo.hasNextPage;
    _loading = false;
  }

  onClosePage() async {
    //_navigationService.back();
    _navigationService.navigateTo(Routes.medLogView);
    notifyListeners();
  }
}
