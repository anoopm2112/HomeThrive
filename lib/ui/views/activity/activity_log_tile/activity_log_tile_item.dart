import 'package:flutter/widgets.dart';

import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityLogTileItem {
  final DateTime date;
  final bool submitted;
  final Child child;
  final ChildLog childLog;
  final void Function(ChildLog childLog) onChildLogChanged;
  final void Function(MedLog medLog) onMedLogChanged;
  final RecreationLog recLog;
  final MedLog medLog;
  final MedLog pastDue;
  final Event events;
  final String logType;
  ChildLogStatus get status => this.submitted
      ? ChildLogStatus.submitted
      : this.childLog != null
          ? ChildLogStatus.incomplete
          : (isSameDay(DateTime.now(), date)
              ? ChildLogStatus.today
              : (date.isAfter(DateTime.now())
                  ? ChildLogStatus.upcoming
                  : ChildLogStatus.missing));

  const ActivityLogTileItem({
    @required this.date,
    this.submitted = false,
    @required this.child,
    this.childLog,
    this.onChildLogChanged,
    this.onMedLogChanged,
    this.recLog,
    this.medLog,
    this.events,
    this.logType,
    this.pastDue,
  })  : assert(date != null),
        assert(submitted != null),
        assert(child != null);

  ActivityLogTileItem copyWith({
    DateTime date,
    bool submitted,
    Child child,
    ChildLog childLog,
    void Function(ChildLog childLog) onChildLogChanged,
    RecreationLog recLog,
    MedLog medLog,
    Event events,
  }) {
    return ActivityLogTileItem(
      date: date ?? this.date,
      submitted: submitted ?? this.submitted,
      child: child ?? this.child,
      childLog: childLog ?? this.childLog,
      onChildLogChanged: onChildLogChanged ?? this.onChildLogChanged,
      recLog: recLog ?? this.recLog,
      medLog: medLog ?? this.medLog,
      events: events ?? this.events,
      logType: logType ?? this.logType,
    );
  }
}
