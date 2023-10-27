import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
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

class AddRecreationLogViewModel extends BaseViewModel {
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

  RecreationLog _childLog;
  RecreationLog get childLog => _childLog;

  AddRecreationLogViewModel({
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
      this._eligibleChildren = await _childrenService.children();

      if (this._eligibleChildren != null) {
        this._family = await _profileService.family();

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

  void onBack() {
    _navigationService.back<RecreationLog>();
  }

  Future<bool> onWillPop() async {
    _navigationService.back<RecreationLog>(result: this._childLog);

    return false;
  }
}
