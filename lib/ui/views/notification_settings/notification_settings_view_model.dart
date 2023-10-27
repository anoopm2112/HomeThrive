import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

enum NSSwitchField {
  newEvent,
  dailyLogReminders,
  monthReviewReminders,
  tipsForEngagement,
  updatesFromCPA
}

// TODO update form model
class NotificationSettingsViewModel extends BaseViewModel {
  final Map<NSSwitchField, bool> _switchFields = <NSSwitchField, bool>{
    NSSwitchField.newEvent: false,
    NSSwitchField.dailyLogReminders: true,
    NSSwitchField.monthReviewReminders: true,
    NSSwitchField.tipsForEngagement: false,
    NSSwitchField.updatesFromCPA: false,
  };

  void onToggleSwitch({
    @required NSSwitchField key,
    @required bool value,
  }) {
    assert(key != null);
    assert(value != null);
    assert(this._switchFields.containsKey(key));

    this._switchFields[key] = value;
    notifyListeners();
  }

  bool switchValue(NSSwitchField key) {
    assert(key != null);
    assert(this._switchFields.containsKey(key));

    return this._switchFields[key];
  }
}
