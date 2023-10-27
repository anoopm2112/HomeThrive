import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/models/input/get_events_input/get_events_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/response/med_log/get_med_logs_response.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/events_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_item.dart';
import 'package:fostershare/ui/views/activity/activity_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarMode {
  events,
  activity,
}

// TODO how to load, when to reload?
// TODO what to happen during failure?
class AuthHomeViewModel extends BaseViewModel {
  final _childrenService = locator<ChildrenService>();
  final _medLogsService = locator<MedLogService>();
  final _eventsService = locator<EventsService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();

  CalendarMode _calendarMode = CalendarMode.events;
  CalendarMode get calendarMode => _calendarMode;

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => this._focusedDay;

  DateTime get _firstDayOfFocusRange =>
      DateTime(_focusedDay.year, _focusedDay.month, 1)
          .subtract(Duration(days: 10))
          .toUtc(); // TODO double check formula
  DateTime get _lastDayOfFocusRange =>
      DateTime(_focusedDay.year, _focusedDay.month, 0)
          .add(Duration(days: 40))
          .toUtc(); // TOFO heper function

  List<Event> _eventsLodaded = <Event>[];

  List<Event> get eventsList => showEventsForMonth
      ? this.eventsForMonth(_focusedDay)
      : this
          .eventLoader(_selectedDay); // TODO make a little more fault talerant

  //bool get showEventsForMonth =>
  //_selectedDay == null || !this.isSameMonth(_focusedDay, _selectedDay);
  bool get showEventsForMonth => _selectedDay == null;
  final Map<String, List<ChildLog>> _childLogs = <String, List<ChildLog>>{};
  final Map<String, List<MedLog>> _medLogs = <String, List<MedLog>>{};
  final Map<String, List<MedLog>> _monthlymedLogs = <String, List<MedLog>>{};
  final Map<String, List<Event>> _events = <String, List<Event>>{};
  final Map<String, List<MedLog>> _submitedMedLogs = <String, List<MedLog>>{};

  ChildrenSummary _childrenSummary = ChildrenSummary();
  bool get hasChildren => this._childrenSummary.hasChildren;

  int _limit = 100;
  GetMedLogsResponse _getMedLogsResponse;
  int get totalCount => _getMedLogsResponse.pageInfo.count;
  bool _loading = false;
  List<MedLog> _pastDueLogs = [];
  List<MedLog> submittedMedLogs = [];
  // on focused day change -> grab new elements
  Future<void> onModelReady() async {
    this._calendarMode = CalendarMode.activity;
    this._selectedDay = DateTime.now();
    await _setFocusedDay(focusedDay);
    //await Future.wait([
    //_setFocusedDay(focusedDay),
    _fetchChildrenSummary();
    _fetchPendingLogs();
    //]);

    // _eventsLodaded = await _eventsService.events(
    //   GetEventsInput(
    //     fromDate: _firstDayOfFocusRange,
    //     toDate: _lastDayOfFocusRange,
    //   ),
    // );

    notifyListeners();
  }

  void onSwitchToggle(bool value) async {
    if (value) {
      this._calendarMode = CalendarMode.activity;
      _fetchChildrenSummary();
    } else {
      this._calendarMode = CalendarMode.events;
      _eventsLodaded = await _eventsService.events(
        GetEventsInput(
          fromDate: _firstDayOfFocusRange,
          toDate: _lastDayOfFocusRange,
        ),
      );
      notifyListeners();
    }
    print(_calendarMode);
  }

  Future<void> _fetchChildrenSummary() async {
    this.setBusy(true);
    _childrenSummary = await _childrenService.childrenSummary(
      GetChildrenLogsInput(
        fromDate: _firstDayOfFocusRange,
        toDate: _lastDayOfFocusRange,
        pagination: CursorPaginationInput(
          limit: 300, // TODO load all?
        ),
      ),
    );

    _childrenSummary.logs.items.childLog.forEach(
      (childLog) {
        _insertChildLog(childLog);
      },
    );
    if (_childrenSummary.logs.items.medLog != null &&
        _childrenSummary.logs.items.medLog.isNotEmpty) {
      _submitedMedLogs.clear();
      _childrenSummary.logs.items.medLog.forEach(
        (medLog) {
          _insertMedLog(medLog);
          _insertSubmittedMedLog(medLog);
        },
      );
    }

    _childrenSummary.logs.items.events.forEach(
      (event) {
        _insertEvents(event);
      },
    );
    _eventsLodaded = _childrenSummary.logs.items.events;
    this.setBusy(false);
    notifyListeners();
  }

  Future<void> _fetchPendingLogs() async {
    this.setBusy(true);
    try {
      _getMedLogsResponse = await _medLogsService.medLogs(
        GetMedLogsInput(
          CursorPaginationInput(
            limit: _limit,
            cursor: _getMedLogsResponse?.pageInfo?.cursor,
          ),
        ),
      );
      //if (_getMedLogsResponse.items.isNotEmpty && _pastDueLogs.length > 0)
      _pastDueLogs.clear();
    } catch (err) {
      this.setBusy(false);
      print(err); //TODO: Handle error
    }

    _pastDueLogs.addAll(_getMedLogsResponse.items.where((element) {
      DateTime now = DateTime.now();
      DateTime lastmnth = DateTime(now.year, now.month - 1);

      var logdate = DateTime(element.year, element.month);
      return lastmnth.compareTo(logdate) >= 0 &&
          element.signingStatus != SigningStatus.COMPLETED;
    }));
    this.setBusy(false);
    notifyListeners();
    _loading = false;
  }

  onTileCreated(int index) async {
    if (_getMedLogsResponse?.pageInfo?.hasNextPage != null &&
        !_getMedLogsResponse.pageInfo.hasNextPage) {
      return;
    }
    if (_loading) {
      return;
    }
    await _fetchPendingLogs();
  }

  Future<void> _setFocusedDay(DateTime focusedDay) async {
    final bool updateLoadedEvents = !this.isSameMonth(
      this._focusedDay,
      focusedDay,
    );
    this._focusedDay = focusedDay;
    notifyListeners();

    // if (updateLoadedEvents) {
    //   _eventsLodaded = await _eventsService.events(
    //     GetEventsInput(
    //       fromDate: _firstDayOfFocusRange,
    //       toDate: _lastDayOfFocusRange,
    //     ),
    //   );
    // }

    // notifyListeners();
  }

  void onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
  ) async {
    assert(selectedDay != null);
    assert(focusedDay != null);

    this._selectedDay = selectedDay;
    await _setFocusedDay(focusedDay);
    notifyListeners();
  }

  List<Event> eventLoader(DateTime day) {
    return _eventsLodaded.where((event) {
      return isSameDay(event.startsAt?.toLocal(), day);
    }).toList()
      ..sort(
        (eventOne, eventTwo) => eventOne.startsAt.compareTo(
          eventTwo.startsAt,
        ),
      );
  }

  List<Event> eventsForMonth(DateTime day) {
    return _eventsLodaded
        .where(
          (event) => isSameMonth(event.startsAt?.toLocal(), day),
        )
        .toList()
          ..sort(
            (eventOne, eventTwo) => eventOne.startsAt.compareTo(
              eventTwo.startsAt,
            ),
          );
  }

  List<ActivityLogTileItem> itemsLoader(DateTime date) {
    var key = date.startOfDateUTCYMD();
    var medKey = DateTime(date.year, date.month, 1).toString();
    final List<ChildLog> submittedLogs =
        _childLogs[date.startOfDateUTCYMD()] ?? [];
    final List<ChildLog> incompleteLogs = <ChildLog>[];
    final List<MedLog> incompleteMedLogs = <MedLog>[];
    final List<MedLog> medLogs = _medLogs[date.toString()] ?? [];
    final List<MedLog> monthlyMedlogs = _monthlymedLogs[medKey] ?? [];
    final List<Event> events = _events[date.startOfDateUTCYMD()] ?? [];
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

    List returnDataLog = _childrenSummary.children.map(
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
          logType: 'childlog',
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
    List returnDataMed = _childrenSummary.children.map(
      (child) {
        bool submitted = false;
        MedLog log = medLogs.firstWhere(
          (log) => log.child.id == child.id,
          orElse: () => null,
        );
        MedLog monthlylog = monthlyMedlogs.firstWhere(
          (log) => log.child.id == child.id,
          orElse: () => null,
        );
        if (log != null && log.entries != null && log.entries.isNotEmpty)
          submitted = true;

        if (log != null &&
            (log.isSubmitted || log.canSign || log.signingStatus != null))
          return ActivityLogTileItem(
            date: date,
            child: child,
          );
        else if (monthlylog != null &&
            (monthlylog.isSubmitted ||
                monthlylog.canSign ||
                monthlylog.signingStatus != null))
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
    // List returnDataMed = medLogs.map(
    //   (medLog) {
    //     return ActivityLogTileItem(
    //         date: date, child: medLog.child, medLog: medLog);
    //   },
    // ).toList();

    List returnDataEvent = events.map((evt) {
      return ActivityLogTileItem(
        date: date,
        child: _childrenSummary.children[0],
        events: evt,
        logType: 'event',
      );
    }).toList();

    return returnDataEvent + returnDataMed + returnDataLog;
  }

  List<ActivityLogTileItem> pastDueLoader() {
    return _pastDueLogs.map((log) {
      var date = DateTime(log.year, log.month + 1, 1);
      return ActivityLogTileItem(
        date: date,
        child: log.child,
        pastDue: log,
      );
    }).toList();
  }

  List<ActivityLogTileItem> submitedMedLogLoader(int month, int year) {
    DateTime date = DateTime(year, month);
    final List<MedLog> submittedMedLogs =
        _submitedMedLogs[month.toString() + "_" + year.toString()] ?? [];

    return submittedMedLogs.map(
      (log) {
        return ActivityLogTileItem(
          date: date,
          child: log.child,
          medLog: log,
          logType: 'submittedMedlog',
          onMedLogChanged: (medLog) {
            if (medLog != null && medLog.id != null) {
              _insertSubmittedMedLog(medLog);
            }
            notifyListeners();
          },
        );
      },
    ).toList();
  }

  void _insertChildLog(ChildLog childLog) {
    final String childLogKey = childLog.date.toLocal().startOfDateUTCYMD();
    if (_childLogs.containsKey(childLogKey)) {
      _childLogs[childLogKey].add(childLog);
    } else {
      _childLogs[childLogKey] = <ChildLog>[childLog];
    }
  }

  void _insertMedLog(MedLog medLog) {
    if (medLog.entries != null && medLog.entries.isNotEmpty) {
      medLog.entries.forEach((entry) {
        String monthlyMedLogKey;
        final String medLogKey = DateTime(
                entry.dateTime.year, entry.dateTime.month, entry.dateTime.day)
            .toLocal()
            .toString();
        if ((entry.dateTime.year == medLog.year) &&
            (entry.dateTime.month == medLog.month))
          monthlyMedLogKey =
              DateTime(entry.dateTime.year, entry.dateTime.month, 1)
                  .toLocal()
                  .toString();
        else
          monthlyMedLogKey =
              DateTime(medLog.year, medLog.month, 1).toLocal().toString();
        if (_medLogs.containsKey(medLogKey)) {
          _medLogs[medLogKey].add(medLog);
        } else {
          _medLogs[medLogKey] = <MedLog>[medLog];
        }
        if (_monthlymedLogs.containsKey(monthlyMedLogKey)) {
          _monthlymedLogs[monthlyMedLogKey].add(medLog);
        } else {
          _monthlymedLogs[monthlyMedLogKey] = <MedLog>[medLog];
        }
      });
    }
  }

  void _insertSubmittedMedLog(MedLog medLog) {
    if (medLog.signingStatus == SigningStatus.COMPLETED) {
      var key = medLog.year != null
          ? DateTime(medLog.year, medLog.month).month.toString() +
              "_" +
              DateTime(medLog.year, medLog.month).year.toString()
          : medLog.createdAt.month.toString() +
              "_" +
              medLog.createdAt.year.toString();
      if (_submitedMedLogs.containsKey(key))
        _submitedMedLogs[key].add(medLog);
      else
        _submitedMedLogs[key] = <MedLog>[medLog];
    }
  }

  void _insertEvents(Event event) {
    final String eventKey = event.startsAt.toLocal().startOfDateUTCYMD();
    // if (_events.containsKey(eventKey)) {
    //   _events[eventKey].add(event);
    // } else {
    _events[eventKey] = <Event>[event];
    //}
  }

  void onPageChanged(DateTime focusedDay) async {
    DateTime foucusday = isSameMonth(this._selectedDay, focusedDay)
        ? this._selectedDay
        : focusedDay;
    this._focusedDay = focusedDay;
    _fetchChildrenSummary();
    _fetchPendingLogs();
    notifyListeners();
  }

  bool isSameMonth(DateTime a, DateTime b) {
    if (a == null || b == null) {
      return false;
    }
    assert(a != null);
    assert(b != null);

    return a.year == b.year && a.month == b.month;
  }

  void onEventDetail(Event event) {
    _navigationService.navigateTo(
      Routes.eventDetailView,
      arguments: EventDetailViewArguments(
          id: event.id, title: event.title, eventDetails: event),
    );
  }

  void medLogDetails() {}
}
