import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/data/log_questions/log_questions.dart';
import 'package:fostershare/core/models/input/get_child_logs_input/get_child_logs_input.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/edit_log_view/edit_log_view.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:stacked/stacked.dart';

class LogSummaryViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _childrenService = locator<ChildrenService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();

  ChildLog _childLog;
  ChildLog get childLog => _childLog;

  ChildLogStatus _status;
  ChildLogStatus get status => this._status;
  bool get canEdit => status == ChildLogStatus.submitted ? true : false;
  // status == ChildLogStatus.submitted &&
  // DateTime.now().difference(childLog.date).inHours <= 24;

  LogSummaryViewModel({
    ChildLog childLog,
    ChildLogStatus status,
  })  : this._childLog = childLog,
        this._status = status;

  Future<void> onModelReady(String id) async {
    _loggerService.info("LogSummaryViewModel - onModelReady(id: $id)");
    if (id != null) {
      this.setBusy(true);

      _childLog = await _childrenService.childLog(
        GetChildLogInput(id: id),
      );

      _childLog.notes.sort((noteA, noteB) =>
          noteA.createdAt.difference(noteB.createdAt).inMicroseconds);

      this.setBusy(false);
    }
  }

  Future<void> onCompleteLog() async {
    _loggerService.info("LogSummaryViewModel - onCompleteLog()");

    final ChildLog log = await _bottomSheetService.addLog(
      date: this._childLog.date,
      child: this._childLog.child,
      skipParentSelection: true,
    );

    if (log != null) {
      this._childLog = log;

      if (this._childLog.id != null) {
        this._status = ChildLogStatus.submitted;
      }
    }

    notifyListeners();
  }

  Future<void> onAddNote() async {
    _loggerService.info("LogSummaryViewModel - onAddNote()");

    final ChildLogNote note = await _bottomSheetService.addNote(
      childLogId: this._childLog.id,
    );

    if (note != null) {
      if (this._childLog.notes == null) {
        this._childLog = this._childLog.copyWith(
          notes: [note],
        );
      } else {
        this._childLog.notes.add(note);
      }
    }

    notifyListeners();
  }

  Future<bool> onWillPopScope() async {
    _navigationService.back<ChildLog>(result: this._childLog);
    return false;
  }

  onTapDayRating() => _editLogEntry(LogQuestion.dayRating);

  onTapParentMood() => _editLogEntry(LogQuestion.parentMood);

  onTapDayBehavioral() => _editLogEntry(LogQuestion.behavioral);

  onTapBioFamilyVisit() => _editLogEntry(LogQuestion.bioFamilyVisit);

  onTapChildMood() => _editLogEntry(LogQuestion.childMood);

  onTapChildMedication() => _editLogEntry(LogQuestion.medication);

  _editLogEntry(LogQuestion logQuestion) async {
    if (canEdit) {
      var newLog = await _showBottomSheet(EditLogView(
        _childLog,
        logQuestion: logQuestion,
      ));
      _childLog = newLog ?? _childLog;
      notifyListeners();
    }
  }

  _showBottomSheet(Widget child) {
    return _bottomSheetService.editLog(child);
  }
}
