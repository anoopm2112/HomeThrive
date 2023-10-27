import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class LogCompleteViewModel extends BaseViewModel {
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();

  ChildLog _childLog;

  LogCompleteViewModel({
    ChildLog childLog,
  }) : this._childLog = childLog;

  void onBack() {
    _loggerService.info("LogCompleteViewModel - onBack()");

    _navigationService.back<ChildLog>(
      result: this._childLog,
    );
  }
}
