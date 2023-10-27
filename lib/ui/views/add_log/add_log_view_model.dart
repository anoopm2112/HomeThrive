import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';

enum LogViewState {
  selectChildAndPArent, // TODO name well
  inputLog,
  logsComplete,
}

class AddLogViewModel extends BaseViewModel {
  final _childrenService = locator<ChildrenService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();

  LogViewState _state = LogViewState.selectChildAndPArent;
  LogViewState get state => _state;

  DateTime _date = DateTime.now().startOfDateLocal().toUtc();
  DateTime get date => this._date;

  Child _child;
  Child get child => _child;

  ChildrenSummary _childrenSummary;

  Family _family;
  Family get family => this._family;

  String _secondaryAuthorId;
  String get secondaryAuthorId => _secondaryAuthorId;

  bool _skipParentSelection;

  List<Child> _eligibleChildren = [];
  List<Child> get eligibleChildren => _eligibleChildren;

  bool get hasChildren => this._childrenSummary.hasChildren;

  ChildLog _childLog;
  ChildLog get childLog => _childLog;

  AddLogViewModel({
    DateTime date,
    Child child,
    bool skipParentSelection = false,
  })  : assert(skipParentSelection != null),
        this._skipParentSelection = skipParentSelection {
    if (date != null) {
      this._date = date.toUtc();
    }

    if (child != null) {
      this._child = child;
    }
  }

  Future<void> onModelReady() async {
    this.setBusy(true);
    this.clearErrors();

    try {
      this._childrenSummary = await _childrenService.childrenSummary(
        GetChildrenLogsInput(
          fromDate: _date,
          toDate: _date.add(Duration(hours: 23, minutes: 59, seconds: 59)),
          pagination: CursorPaginationInput(
            limit: 20, // TODO need all in a day
          ),
        ),
      );

      if (this.hasChildren) {
        this._family = await _profileService.family();

        this._eligibleChildren = this
            ._childrenSummary
            .children
            .where(
              (child) => !this._childrenSummary.logs.items.childLog.any(
                    (log) => log.child.id == child.id,
                  ),
            )
            .toList();

        final bool shouldSelectParent =
            this._family.hasSecondaryParents && !this._skipParentSelection;

        final bool logsComplete = this._eligibleChildren.length == 0;
        final bool oneChildLogRemaining = this._eligibleChildren.length == 1;

        if (logsComplete) {
          this._state = LogViewState.logsComplete;
        } else if (!shouldSelectParent) {
          if (this._child == null && oneChildLogRemaining) {
            this._child = this._eligibleChildren.single;
          }

          if (this._child != null) {
            this._state = LogViewState.inputLog;
          }
        }
      }
    } catch (e) {
      // TODO log
      this.setError("Loading Error");
    }

    this.setBusy(false);
  }

  void onSelectParentAndChildComplete({
    Child child,
    String secondaryAuthorId,
  }) {
    this._child = child;
    this._secondaryAuthorId = secondaryAuthorId;
    this._state = LogViewState.inputLog;

    notifyListeners();
  }

  void onChildLogChanged(ChildLog childLog) {
    this._childLog = childLog;
    if (this._childLog.id != null) {
      this._state = LogViewState.logsComplete;
      notifyListeners();
    }
  }

  void onBack() {
    _navigationService.back<ChildLog>();
  }

  Future<bool> onWillPop() async {
    _navigationService.back<ChildLog>(result: this._childLog);

    return false;
  }
}
