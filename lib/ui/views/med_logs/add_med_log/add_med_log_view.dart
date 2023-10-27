import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/add_med_log/add_med_log_view_model.dart';
import 'package:fostershare/ui/views/med_logs/med_log_detail_view/med_log_detail_view.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view.dart';
import 'package:fostershare/ui/views/med_logs/select_child/select_child_view.dart';
import 'package:stacked/stacked.dart';

class AddMedLogView extends StatelessWidget {
  final DateTime date;
  final Child child;
  final bool skipParentSelection;
  final MedLog medLog;
  final bool previewPage;
  final bool detailPage;

  const AddMedLogView({
    Key key,
    this.date,
    this.child,
    this.skipParentSelection = false,
    this.medLog,
    this.previewPage = false,
    this.detailPage = false,
  })  : assert(skipParentSelection != null && skipParentSelection
            ? child != null
            : true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ViewModelBuilder<AddMedLogViewModel>.reactive(
        viewModelBuilder: () => AddMedLogViewModel(
              date: this.date,
              child: this.child,
              skipParentSelection: this.skipParentSelection,
              medLogs: medLog,
              previewPage: previewPage,
              detailPage: detailPage,
            ),
        onModelReady: (model) => model.onModelReady(),
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: model.onWillPop,
            child: model.isBusy
                ? Center(
                    // TODO
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : model.hasError
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: defaultViewChildPaddingHorizontal,
                            child: Text(
                              localization.errorLoadingChildren,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 24),
                          TextButton(
                            onPressed: model.onModelReady,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sync,
                                  color: textTheme.button.color,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  localization.reload,
                                  style: textTheme.button, // TODO
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (model.availableLogsToCreate == null ||
                            model.availableLogsToCreate.isEmpty &&
                                model.state != LogViewState.logsPreview &&
                                model.state != LogViewState.logsDetail)
                        ? Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 12),
                                child: GestureDetector(
                                  onTap: model.onBack,
                                  child: Icon(
                                    Icons.close,
                                    size: 32,
                                    color: Color(0xFF95A1AC), // TODO
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: defaultViewChildPaddingHorizontal,
                                    child: Text(
                                      localization.noChildren,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  TextButton(
                                    onPressed: model.onModelReady,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.sync,
                                          color: textTheme.button.color,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          localization.reload,
                                          style: textTheme.button, // TODO
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : _viewForState(model),
          );
        });
  }

  Widget _viewForState(AddMedLogViewModel model) {
    switch (model.state) {
      case LogViewState.logsPreview:
        return MedLogSummaryView(
          medLog: model.medLog,
        );
      case LogViewState.logsDetail:
        return MedLogDetailView(
          medLog: model.medLog,
        );
      case LogViewState.inputLog:
        return MedLogInputView(
          date: model.date,
          child: model.child,
          medLog: model.medLog,
          onMedLogChanged: model.onMedLogChanged,
          secondaryAuthorId: model.secondaryAuthorId,
        );
      case LogViewState.selectChild:
      default:
        return SelectChildView(
          children: model.eligibleChildren,
          availableMedLogs: model.availableLogsToCreate,
          family: model.family,
          initialSelectedChild: model.child,
          onChildAndParentSelected: model.onSelectParentAndChildComplete,
        );
    }
  }
}
