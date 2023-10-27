import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/response/med_log/get_med_logs_response.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:stacked/stacked.dart';

import 'create_med_log_view.dart';

class MedLogViewModel extends BaseViewModel {
  final _medLogsService = locator<MedLogService>();
  final _navigationService = locator<NavigationService>();

  int _limit = 10;
  GetMedLogsResponse _getMedLogsResponse;
  int get totalCount => _getMedLogsResponse.pageInfo.count;
  bool _loading = false;
  List<MedLog> logs = [];
  //TODO: implement can sign logic

  Future<void> onModelReady() async {
    setBusy(true);
    await Future.wait([_loadMedLogs()]);
    setBusy(false);
  }

  onTapMedLog(MedLog medLog) {
    _navigationService.navigateTo(
      Routes.medLogDetailsView,
      arguments: MedLogDetailsViewArguments(medLogId: medLog.id),
    );
  }

  onTapAdd() async {
    var newMedLog = await showModalBottomSheet<MedLog>(
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
        child: CreateMedLogView(),
      ),
    );
    if (newMedLog != null) {
      if (logs == null) {
        logs = [newMedLog];
      } else {
        logs.add(newMedLog);
      }
    }
    notifyListeners();
  }

  onTileCreated(int index) async {
    if (_getMedLogsResponse?.pageInfo?.hasNextPage != null &&
        !_getMedLogsResponse.pageInfo.hasNextPage) {
      return;
    }
    if (_loading) {
      return;
    }
    await _loadMedLogs();
  }

  Future _loadMedLogs() async {
    _loading = true;
    try {
      _getMedLogsResponse = await _medLogsService.medLogs(
        GetMedLogsInput(
          CursorPaginationInput(
            limit: _limit,
            cursor: _getMedLogsResponse?.pageInfo?.cursor,
          ),
        ),
      );
    } catch (err) {
      print(err); //TODO: Handle error
    }
    logs.addAll(_getMedLogsResponse.items);
    notifyListeners();
    _loading = false;
  }

  onClosePage() async {
    _navigationService.navigateTo(Routes.bottomNavView);
    notifyListeners();
  }
}
