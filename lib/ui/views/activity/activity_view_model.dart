import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_item.dart';
import 'package:stacked/stacked.dart';

class ChildButtomData {
  // TODO rename
  final String label;
  final Child child;

  ChildButtomData({
    this.label,
    this.child,
  });
}

// TODO account for no children
class ActivityViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _childrenService = locator<ChildrenService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _loggerService = locator<LoggerService>();

  static final int _allChildrenLogsIndex = 0; // TODO should it be static

  List<ChildButtomData> _labels = <ChildButtomData>[];
  List<String> get labels => _labels
      .map(
        (item) => item.label,
      )
      .toList();

  int _selectedLabelIndex = _allChildrenLogsIndex;
  int get selectedLabelIndex => _selectedLabelIndex;

  final Map<String, List<ChildLog>> _childLogs = <String, List<ChildLog>>{};
  final Map<String, List<RecreationLog>> _recLogs =
      <String, List<RecreationLog>>{};
  final Map<String, List<MedLog>> _medLogs = <String, List<MedLog>>{};
  final Map<String, List<MedLog>> _submitedMedLogs = <String, List<MedLog>>{};

  ChildrenSummary _childrenSummary;
  bool get hasLogs => _childrenSummary.hasLogs;
  bool get hasChildren => _childrenSummary.hasChildren;

  List<DateTime> _days = [];
  List<DateTime> get dates => _days;

  Future<void> onModelReady() async {
    this.setBusy(true);

    try {
      await _fetchChildLogs();
    } catch (e, s) {
      this.setError("Loading Error");
      _loggerService.error(
        "Couldn't fetch logs",
        error: e,
        stackTrace: s,
      );
    }

    this.setBusy(false);
  }

  Future<void> _fetchChildLogs() async {
    _childrenSummary = await _childrenService.childrenSummary(
      GetChildrenLogsInput(
        pagination: CursorPaginationInput(
          limit: 30, // TODO fip fitler - get most recent first
        ),
      ),
    );

    if (this.hasChildren) {
      _childLogs.clear();
      // _medLogs.clear();
      _recLogs.clear();
      _labels = _childrenSummary.children
          .map(
            (child) => ChildButtomData(
              label: child.nickName ?? child.firstName,
              child: child,
            ),
          )
          .toList()
            ..insert(
              _allChildrenLogsIndex,
              ChildButtomData(label: "All"),
            );

      _childrenSummary.logs.items.childLog.forEach(
        (childLog) {
          _insertChildLog(childLog);
        },
      );
      _childrenSummary.logs.items.recreationLog.forEach(
        (recLog) {
          _insertRecLog(recLog);
        },
      );
      _childrenSummary.logs.items.medLog.forEach(
        (medLog) {
          _insertMedLog(medLog);
        },
      );

      if (this.hasLogs) {
        DateTime dayOfFirstLog;
        if (_childrenSummary.logs.items.childLog.isNotEmpty) {
          dayOfFirstLog = _childrenSummary.logs.items.childLog.fold<DateTime>(
            _childrenSummary.logs.items.childLog.first.date,
            (date, log) =>
                log.date.difference(date).isNegative ? log.date : date,
          );
        }
        // if (_childrenSummary.logs.items.medLog.isNotEmpty) {
        //   var firstDate = _childrenSummary.logs.items.medLog.first.year != null
        //       ? DateTime(_childrenSummary.logs.items.medLog.first.year,
        //           _childrenSummary.logs.items.medLog.first.month, 1)
        //       : _childrenSummary.logs.items.medLog.first.createdAt;
        //   dayOfFirstLog = _childrenSummary.logs.items.medLog
        //       .fold<DateTime>(firstDate, (date, log) {
        //     DateTime logdate = log.year != null
        //         ? DateTime(log.year, log.month, 1)
        //         : log.createdAt;
        //     return logdate.difference(date).isNegative ? logdate : date;
        //   });
        // }
        DateTime today = DateTime.now();
        DateTime prev = DateTime(today.year, today.month - 1, 1);
        _days = getDaysInBetween(
          dayOfFirstLog != null ? dayOfFirstLog.toLocal() : prev,
          DateTime.now(),
        );
      }
    }
  }

  void _insertChildLog(ChildLog childLog) {
    final String childLogKey = childLog.date.toLocal().startOfDateUTCYMD();
    if (_childLogs.containsKey(childLogKey)) {
      _childLogs[childLogKey].add(childLog);
    } else {
      _childLogs[childLogKey] = <ChildLog>[childLog];
    }
  }

  void _insertRecLog(RecreationLog recLog) {
    final String recLogKey = recLog.createdAt.toLocal().startOfDateUTCYMD();
    if (_recLogs.containsKey(recLogKey)) {
      _recLogs[recLogKey].add(recLog);
    } else {
      _recLogs[recLogKey] = <RecreationLog>[recLog];
    }
  }

  void _insertMedLog(MedLog medLog) {
    if (medLog.entries != null && medLog.entries.isNotEmpty) {
      medLog.entries.forEach((entry) {
        final String medLogKey = DateTime(
                entry.dateTime.year, entry.dateTime.month, entry.dateTime.day)
            .toLocal()
            .toString();
        if (_medLogs.containsKey(medLogKey)) {
          _medLogs[medLogKey].add(medLog);
        } else {
          _medLogs[medLogKey] = <MedLog>[medLog];
        }
      });
    }
  }

  void onLabelPressed(int index) {
    // TODO add assertions
    _selectedLabelIndex = index;
    notifyListeners();
  }

  void onLogCardCreated(int index) {}

  List<ActivityLogTileItem> itemsLoader(DateTime date) {
    final List<ChildLog> submittedLogs =
        _childLogs[date.startOfDateUTCYMD()] ?? [];
    final List<ChildLog> incompleteLogs = <ChildLog>[];
    final List<RecreationLog> recLogs =
        _recLogs[date.startOfDateUTCYMD()] ?? [];
    final List<MedLog> medLogs = _medLogs[date.toString()] ?? [];
    _childrenSummary.children.forEach(
      (child) {
        final String storageKey = childLogStorageKey(
          child: child,
          date: date,
        );
        if (_keyValueStorageService.containsKey(storageKey)) {
          incompleteLogs.add(
            _keyValueStorageService.get<ChildLog>(storageKey),
          );
        }
      },
    );

    List returnDataLog = _childrenSummary.children
        .where(
      (child) => this.selectedLabelIndex != _allChildrenLogsIndex
          ? child.id == _labels[this.selectedLabelIndex].child.id
          : true,
    )
        .map(
      (child) {
        bool submitted = true;

        ChildLog log = submittedLogs.firstWhere(
          (log) => log.child.id == child.id,
          orElse: () => null,
        );

        if (log == null) {
          submitted = false;
          log = incompleteLogs.firstWhere(
            (log) => log.child.id == child.id,
            orElse: () => null,
          );
        }

        return ActivityLogTileItem(
          date: date,
          submitted: submitted,
          child: child,
          childLog: log,
          logType: "childlog",
          onChildLogChanged: (childLog) {
            if (childLog != null && childLog.id != null) {
              _insertChildLog(childLog);
            }
            notifyListeners();
          },
        );
      },
    ).toList()
          ..sort(
            (logDataA, logDataB) =>
                -logDataA.child.age.compareTo(logDataB.child.age),
          );
    List returnDataRec = recLogs
        .where(
      (log) => this.selectedLabelIndex != _allChildrenLogsIndex
          ? log.child.id == _labels[this.selectedLabelIndex].child.id
          : true,
    )
        .map(
      (recLog) {
        return ActivityLogTileItem(
          date: date,
          child: recLog.child,
          recLog: recLog,
          logType: "reclog",
        );
      },
    ).toList();
    List returnDataMed = _childrenSummary.children
        .where(
      (child) => this.selectedLabelIndex != _allChildrenLogsIndex
          ? child.id == _labels[this.selectedLabelIndex].child.id
          : true,
    )
        .map(
      (child) {
        bool submitted = true;

        MedLog log = medLogs.firstWhere(
          (log) => log.child.id == child.id,
          orElse: () => null,
        );
        if (log == null)
          return ActivityLogTileItem(
            date: date,
            child: child,
          );
        else
          return ActivityLogTileItem(
            date: date,
            submitted: submitted,
            child: child,
            medLog: log,
            logType: 'medlog',
            onMedLogChanged: (medLog) {
              if (medLog != null && medLog.id != null) {
                _insertMedLog(medLog);
              }
              notifyListeners();
            },
          );
      },
    ).toList()
          ..sort(
            (logDataA, logDataB) =>
                -logDataA.child.age.compareTo(logDataB.child.age),
          );
    // List returnDataMed = medLogs
    //     .where(
    //   (log) => this.selectedLabelIndex != _allChildrenLogsIndex
    //       ? log.child.id == _labels[this.selectedLabelIndex].child.id
    //       : true,
    // )
    //     .map(
    //   (medLog) {
    //     return ActivityLogTileItem(
    //       date: date,
    //       child: medLog.child,
    //       medLog: medLog,
    //       logType: "medlog",
    //     );
    //   },
    // ).toList();
    return returnDataMed + returnDataLog + returnDataRec;
  }

  Future<void> onRefresh() async {
    await _fetchChildLogs();

    notifyListeners();
  }

  void onAddLog() {
    _bottomSheetService.addLog();
  }

  List<ActivityLogTileItem> submitedMedLogLoader(int month, int year) {
    DateTime date = DateTime(year, month);
    final List<MedLog> submittedLogs =
        _submitedMedLogs[month.toString() + "_" + year.toString()] ?? [];

    return submittedLogs.map(
      (log) {
        return ActivityLogTileItem(
          date: date,
          child: log.child,
          logType: 'submittedMedlog',
          onMedLogChanged: (medLog) {
            if (medLog != null && medLog.id != null) {
              _insertMedLog(medLog);
            }
            notifyListeners();
          },
        );
      },
    ).toList()
      ..sort(
        (logDataA, logDataB) =>
            -logDataA.child.age.compareTo(logDataB.child.age),
      );
  }
}

DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  final List<DateTime> days = [];
  for (int dayIndex = 0;
      dayIndex >= startDate.difference(endDate).inDays;
      dayIndex--) {
    days.add(
      DateTime(
        endDate.year,
        endDate.month,
        endDate.day + dayIndex,
      ),
    );
  }
  return days;
}
