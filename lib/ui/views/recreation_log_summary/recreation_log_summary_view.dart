import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/recreation_log_summary/recreation_log_summary_view_model.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:fostershare/ui/widgets/recreation_log_column.dart';
import 'package:stacked/stacked.dart';

class RecreationLogSummaryView extends StatefulWidget {
  RecreationLogSummaryView(this.recLogId);
  final String recLogId;

  @override
  State<StatefulWidget> createState() => _RecreationLogSummaryViewState();
}

class _RecreationLogSummaryViewState extends State<RecreationLogSummaryView> {
  RecreationLogSummaryViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<RecreationLogSummaryViewModel>.reactive(
      viewModelBuilder: () => RecreationLogSummaryViewModel(widget.recLogId),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.recreationLog,
              style: theme.appBarTheme.titleTextStyle.copyWith(
                fontSize: getResponsiveMediumFontSize(context),
              ),
            ),
          ),
          body: SafeArea(
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    )
                  : _recLogDetails()),
        );
      },
    );
  }

  Widget _recLogDetails() {
    //final localization = AppLocalizations.of(context);
    return SingleChildScrollView(
        child: RecreationLogColumn(
      reCreationActivityComments: model.recreationLog.activityComment,
      dailyIndoorOutdoorActivity:
          model.recreationLog.dailyIndoorOutdoorActivity,
      indivitualFreeTimeActivity:
          model.recreationLog.individualFreeTimeActivity,
      communityActivity: model.recreationLog.communityActivity,
      familyActivity: model.recreationLog.familyActivity,
      endBorder: true,
    ));
  }
}
