import 'package:fostershare/app/locator.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/response/get_recreation_logs_response/get_recreation_logs_response.dart';
import 'package:fostershare/ui/views/recreation_log_summary/recreation_log_summary_view.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_recreation_logs_input/get_recreation_logs_input.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/recreaction_log_services.dart';
import 'package:fostershare/ui/views/recreation_log/add_recreation_log/add_recreation_log_view.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:stacked/stacked.dart';

class RecreationLogViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _loggerService = locator<LoggerService>();
  final _recLogsService = locator<RecreationLogService>();
  bool _loading = false;
  int _limit = 10;

  GetRecreationLogsResponse _recreationLog;
  int get totalCount => _recreationLog.pageInfo.count;
  List<RecreationLog> recreationLog = [];

  Future<void> onModelReady() async {
    setBusy(true);
    await Future.wait([_fetchRecLogs()]);
    notifyListeners();
    setBusy(false);
  }

  Future _fetchRecLogs() async {
    _loading = true;
    var result = await _recLogsService.recreationLogs(
      GetRecreationLogsInput(
        pagination: CursorPaginationInput(
          cursor: this._recreationLog?.pageInfo?.cursor,
          limit: this._limit,
        ),
      ),
    );
    _recreationLog = result;
    print(result);
    recreationLog.addAll(result.items);
    _loading = false;
    notifyListeners();
  }

  onTileCreated(int index) async {
    if (index <= recreationLog.length - 5) {
      // Load at 5 images before end
      return;
    }
    if (recreationLog.length >= _recreationLog.pageInfo.count) {
      return;
    }
    if (_recreationLog.pageInfo.hasNextPage == false) {
      return;
    }
    if (_loading) {
      return;
    }
    await _fetchRecLogs();
    notifyListeners();
  }

  onTileTap(String recLogId) async {
    await _navigationService.navigateTo(
      Routes.recreationLogSummaryView,
      arguments: RecreationLogSummaryViewArguments(recLogId: recLogId),
    );
  }

  void onBack() {
    _navigationService.back();
  }

  onNewRecLog() async {
    _loggerService.info(
      "AuthBottomNavViewModel - onNewRecLog()",
    );
    var newRecLog = await showModalBottomSheet<RecreationLog>(
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
        child: AddRecreationLogView(),
      ),
    );
    if (newRecLog != null) {
      if (recreationLog == null) {
        recreationLog = [newRecLog];
      } else {
        recreationLog.insert(0, newRecLog);
      }
    }
    notifyListeners();
  }

  void onRecLogView() {
    _loggerService.info(
      "MyChildrenViewModel - onChildLogTap()",
    );

    _navigationService.navigateTo(
      Routes.logSummaryView,
      // arguments: RecreationLogSummaryView(
      //     //question: log.id,
      //     // date: log.date,
      //     // child: this.selectedChild,
      //     ),
    );
  }
}
