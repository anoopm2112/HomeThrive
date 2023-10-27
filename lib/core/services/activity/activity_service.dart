import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/services/activity/utils.dart';
import 'package:fostershare/core/services/children_service.dart';

class ActivityService {
  final _childrenService = locator<ChildrenService>();

  final Map<DateTime, List<ChildLog>> _childLogs = <DateTime, List<ChildLog>>{};
  Map<DateTime, List<ChildLog>> get childLogs => _childLogs;

  Future<ChildrenSummary> childrenSummary() async {
    final ChildrenSummary childrenSummary =
        await _childrenService.childrenSummary(
      GetChildrenLogsInput(
        pagination: CursorPaginationInput(
          limit: 5,
        ),
      ),
    );

    childrenSummary.logs.items.childLog.forEach(
      (childLog) {
        final DateTime startOfDayInUtc = startOfDayUTC(childLog.date);
        if (_childLogs.containsKey(startOfDayInUtc)) {
          _childLogs[startOfDayInUtc].add(childLog);
        } else {
          _childLogs[startOfDayInUtc] = <ChildLog>[childLog];
        }
      },
    );

    return childrenSummary;
  }
}
