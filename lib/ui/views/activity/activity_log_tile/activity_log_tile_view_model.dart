import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_item.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

class ActivityLogTileViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();

  void onLogCardCreated(int index) {}

  // TODO constructor wosn't working

  Future<void> onTap(ActivityLogTileItem item) async {
    final ChildLog childLog = item.childLog;
    ChildLog updatedChildLog;

    if (childLog != null) {
      updatedChildLog = await _navigationService.navigateTo<ChildLog>(
        Routes.logSummaryView,
        arguments: LogSummaryViewArguments(
          id: childLog.id,
          childLog: childLog,
          status: item.status,
          date: childLog.date,
          child: item.child,
        ),
      );
    } else {
      updatedChildLog = await _bottomSheetService.addLog(
        date: item.date,
        child: item.child,
      );

      notifyListeners();
    }

    print(updatedChildLog);
    print(updatedChildLog?.id);

    if (updatedChildLog != null) {
      item.onChildLogChanged?.call(updatedChildLog);
    }
  }

  onRecTap(String recLogId) async {
    await _navigationService.navigateTo(
      Routes.recreationLogSummaryView,
      arguments: RecreationLogSummaryViewArguments(recLogId: recLogId),
    );
  }

  Future<void> onMedLogTap(ActivityLogTileItem item) async {
    final MedLog medLog = item.medLog;
    MedLog updatedMedLog;

    if (medLog != null && medLog.isSubmitted) {
      updatedMedLog = await _bottomSheetService.addMedLog(
          date: item.date, medLog: medLog, child: item.child, detailPage: true);
    } else {
      updatedMedLog = await _bottomSheetService.addMedLog(
          date: item.date,
          medLog: medLog ?? null,
          child: item.child,
          skipParentSelection: true);

      notifyListeners();
    }

    if (updatedMedLog != null) {
      item.onMedLogChanged?.call(updatedMedLog);
    }
  }

  Future<void> onSubmittedMedLogDetailsTap(ActivityLogTileItem item) async {
    final MedLog medLog = item.medLog;
    MedLog updatedMedLog;

    if (medLog != null) {
      updatedMedLog = await _bottomSheetService.addMedLog(
          date: item.date, child: item.child, medLog: medLog, detailPage: true);

      notifyListeners();
    }

    // if (updatedMedLog != null) {
    //   item.onMedLogChanged?.call(updatedMedLog);
    // }
  }

  Future<void> onMedLogDetailsTap(ActivityLogTileItem item) async {
    final MedLog medLog = item.pastDue;
    MedLog updatedMedLog;

    if (medLog != null) {
      if (medLog.signingStatus != SigningStatus.COMPLETED)
        updatedMedLog = await _bottomSheetService.addMedLog(
            date: item.date,
            child: item.child,
            medLog: medLog,
            previewPage: true);

      notifyListeners();
    } else {
      updatedMedLog = await _bottomSheetService.addMedLog(
          date: item.date, child: item.child, skipParentSelection: true);

      notifyListeners();
    }

    // if (updatedMedLog != null) {
    //   item.onMedLogChanged?.call(updatedMedLog);
    // }
  }

  onEventDetail(Event event) {
    _navigationService.navigateTo(
      Routes.eventDetailView,
      arguments: EventDetailViewArguments(
          id: event.id, title: event.title, eventDetails: event),
    );
  }
}
