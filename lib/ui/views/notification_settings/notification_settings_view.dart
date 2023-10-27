import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/notification_settings/notification_settings_row.dart';
import 'package:fostershare/ui/views/notification_settings/notification_settings_view_model.dart';
import 'package:stacked/stacked.dart';

class NotificationSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<NotificationSettingsViewModel>.reactive(
      viewModelBuilder: () => NotificationSettingsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Color(0xFF000000).withOpacity(.15), // TODO
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFFFFFF), // TODO
            ),
          ),
          title: Text(
            localization.notifications,
            style: theme.appBarTheme.titleTextStyle.copyWith(
              fontSize: getResponsiveMediumFontSize(context),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFDEE2E7),
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationSettingsRow(
                title: localization.newEvent,
                value: model.switchValue(
                  NSSwitchField.newEvent,
                ),
                onToggle: (value) => model.onToggleSwitch(
                  key: NSSwitchField.newEvent,
                  value: value,
                ),
              ),
              NotificationSettingsRow(
                title: localization.dailyLogReminders,
                value: model.switchValue(
                  NSSwitchField.dailyLogReminders,
                ),
                onToggle: (value) => model.onToggleSwitch(
                  key: NSSwitchField.dailyLogReminders,
                  value: value,
                ),
              ),
              NotificationSettingsRow(
                title: localization.monthlyReviewReminders,
                value: model.switchValue(
                  NSSwitchField.monthReviewReminders,
                ),
                onToggle: (value) => model.onToggleSwitch(
                  key: NSSwitchField.monthReviewReminders,
                  value: value,
                ),
              ),
              NotificationSettingsRow(
                title: localization.engagementTips,
                value: model.switchValue(
                  NSSwitchField.tipsForEngagement,
                ),
                onToggle: (value) => model.onToggleSwitch(
                  key: NSSwitchField.tipsForEngagement,
                  value: value,
                ),
              ),
              NotificationSettingsRow(
                title: localization.updatesFromCPA,
                value: model.switchValue(
                  NSSwitchField.updatesFromCPA,
                ),
                onToggle: (value) => model.onToggleSwitch(
                  key: NSSwitchField.updatesFromCPA,
                  value: value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
