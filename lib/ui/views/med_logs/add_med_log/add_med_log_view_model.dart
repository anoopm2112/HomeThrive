import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/response/med_log/get_med_logs_response.dart';
import 'package:fostershare/core/models/input/med_log/med_log_date_input.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';

enum LogViewState {
  selectChild, // TODO name well
  inputLog,
  logsPreview,
  logsDetail,
}

class AddMedLogViewModel extends BaseViewModel {
  final _childrenService = locator<ChildrenService>();
  final _medLogsService = locator<MedLogService>();
  final _navigationService = locator<NavigationService>();
  final _profileService = locator<ProfileService>();

  LogViewState _state = LogViewState.selectChild;
  LogViewState get state => _state;

  GetMedLogsResponse _getMedLogsResponse;
  DateTime _date = DateTime.now().startOfDateLocal();
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
  List<MedLog> _existingLogs = [];
  List<MedLog> availableLogsToCreate = [];
  int _limit = 10000000;
  MedLog _medLog;
  MedLog get medLog => _medLog;
  final Map<String, List<MedLog>> _medLogs = <String, List<MedLog>>{};
  MedLogDateInput _fd; //To cache the calculated from date
  MedLogDateInput _td; //To cache the calculated to date
  DateTime _ct; //To cache value of current time

  AddMedLogViewModel({
    DateTime date,
    Child child,
    bool skipParentSelection = false,
    MedLog medLogs,
    bool previewPage = false,
    bool detailPage = false,
  })  : assert(skipParentSelection != null),
        this._skipParentSelection = skipParentSelection {
    if (date != null) {
      this._date = date;
    }
    this._state = previewPage
        ? LogViewState.logsPreview
        : detailPage
            ? LogViewState.logsDetail
            : skipParentSelection
                ? LogViewState.inputLog
                : LogViewState.selectChild;
    if (child != null) {
      this._child = child;
    }
    if (medLogs != null) {
      this._medLog = medLogs;
    }
  }

  Future<void> onModelReady() async {
    this.setBusy(true);
    if (this._medLog != null) {
      this._medLog = await _medLogsService.medLog(GetMedLogInput(_medLog.id));
    }
    this.clearErrors();
    if (_state == LogViewState.logsPreview ||
        _state == LogViewState.logsDetail) {
      this.setBusy(false);
      notifyListeners();
      return;
    }

    await _loadMedLogs();

    var datesRange = _datesRange;
    for (var i in datesRange) {
      for (var j in _eligibleChildren) {
        var exists = _existingLogs.any((element) =>
            element.child.id == j.id &&
            element.year == i.year &&
            element.month == i.month &&
            element.signingStatus == SigningStatus.COMPLETED);

        final String medLogKey =
            j.id + "_" + i.year.toString() + "_" + i.month.toString();
        MedLog medlog;

        if (_medLogs.containsKey(medLogKey)) medlog = _medLogs[medLogKey][0];

        if (!exists) {
          availableLogsToCreate.add(
            medlog != null
                ? medlog
                : MedLog(
                    month: i.month,
                    year: i.year,
                    child: Child(
                      id: j.id,
                      imageURL: j.imageURL,
                      firstName: j.firstName,
                      lastName: j.lastName,
                    ),
                  ),
          );
        }
        if (_skipParentSelection) {
          if (_child != null && _child.id == j.id) {
            _medLog = medlog != null
                ? medlog
                : MedLog(
                    month: i.month,
                    year: i.year,
                    child: Child(
                      id: j.id,
                      imageURL: j.imageURL,
                      firstName: j.firstName,
                      lastName: j.lastName,
                    ),
                  );
          }
        }
      }
    }

    this.setBusy(false);
  }

  void onSelectParentAndChildComplete({
    Child child,
    String secondaryAuthorId,
    MedLog medlog,
  }) {
    this._child = child;
    this._secondaryAuthorId = secondaryAuthorId;
    this._medLog = medlog;
    this._state = LogViewState.inputLog;
    notifyListeners();
  }

  void onMedLogChanged(MedLog medLog) {
    this._medLog = medLog;
    if (this._medLog.id != null) {
      this.onBack();
      notifyListeners();
    }
  }

  void onBack() {
    _navigationService.back<MedLog>(result: this._medLog);
  }

  Future<bool> onWillPop() async {
    _navigationService.back<MedLog>(result: this._medLog);
    return false;
  }

  _loadMedLogs() async {
    try {
      _eligibleChildren = await _childrenService.children();
      this._family = await _profileService.family();
      _getMedLogsResponse = await _medLogsService.medLogs(
          GetMedLogsInput(
            CursorPaginationInput(
              limit: _limit,
              cursor: _getMedLogsResponse?.pageInfo?.cursor,
            ),
            fromDate: _fromDate,
            toDate: _toDate,
          ),
          extendedDetails: true);
    } catch (err) {
      this.setError("Loading Error");
      print(err); //TODO: Handle error
    }
    if (_getMedLogsResponse.items != null) {
      _getMedLogsResponse.items.forEach((medLog) {
        final String medLogKey = medLog.child.id +
            "_" +
            medLog.year.toString() +
            "_" +
            medLog.month.toString();
        if (_medLogs.containsKey(medLogKey)) {
          _medLogs[medLogKey].add(medLog);
        } else {
          _medLogs[medLogKey] = <MedLog>[medLog];
        }
      });
    }

    _existingLogs.addAll(_getMedLogsResponse.items);
  }

  MedLogDateInput get _fromDate {
    var currentDate = _date;
    var fromDate = DateTime(
        currentDate.year, currentDate.month); // Load from current month
    _fd = MedLogDateInput(fromDate.year, fromDate.month);
    return _fd;
  }

  MedLogDateInput get _toDate {
    var currentDate = _date;
    _td = MedLogDateInput(currentDate.year, currentDate.month);
    return _td;
  }

  DateTime get _currentTime {
    if (_ct != null) {
      return _ct;
    }
    _ct = DateTime.now();
    return _ct;
  }

  List<MedLogDateInput> get _datesRange {
    var fromDate = _fromDate;
    var toDate = _toDate;
    List<MedLogDateInput> range = [];
    var _iDate = DateTime(fromDate.year, fromDate.month);
    while (true) {
      range.add(MedLogDateInput(_iDate.year, _iDate.month));
      _iDate = DateTime(_iDate.year, _iDate.month + 1);
      if (_iDate.year > _toDate.year || _iDate.month > _toDate.month) {
        break;
      }
    }
    return range;
  }
}
