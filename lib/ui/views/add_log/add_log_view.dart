import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/add_log/add_log_view_model.dart';
import 'package:fostershare/ui/views/add_log/log_complete/log_complete_view.dart';
import 'package:fostershare/ui/views/add_log/log_input/log_input_view.dart';
import 'package:fostershare/ui/views/add_log/select_child_and_parent/select_child_and_parent_view.dart';
import 'package:stacked/stacked.dart';

class AddLogView extends StatelessWidget {
  final DateTime date;
  final Child child;
  final bool skipParentSelection;

  const AddLogView({
    Key key,
    this.date,
    this.child,
    this.skipParentSelection = false,
  })  : assert(skipParentSelection != null && skipParentSelection
            ? child != null
            : true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ViewModelBuilder<AddLogViewModel>.reactive(
        viewModelBuilder: () => AddLogViewModel(
              date: this.date,
              child: this.child,
              skipParentSelection: this.skipParentSelection,
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
                    : !model.hasChildren
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

  Widget _viewForState(AddLogViewModel model) {
    switch (model.state) {
      case LogViewState.logsComplete:
        return LogCompleteView(
          childLog: model.childLog,
        );
      case LogViewState.inputLog:
        return LogInputView(
          date: model.date,
          child: model.child,
          onChildLogChanged: model.onChildLogChanged,
          secondaryAuthorId: model.secondaryAuthorId,
        );
      case LogViewState.selectChildAndPArent:
      default:
        return SelectChildAndParentView(
          children: model.eligibleChildren,
          family: model.family,
          initialSelectedChild: model.child,
          onChildAndParentSelected: model.onSelectParentAndChildComplete,
        );
    }
  }
}
