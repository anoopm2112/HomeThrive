import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/components/view_bar/view_bar.dart';
import 'package:fostershare/ui/views/activity/activity_scroll_view.dart';
import 'package:fostershare/ui/views/activity/activity_view_model.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:fostershare/ui/widgets/horizontal_buttons_list_view.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ActivityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<ActivityViewModel>.reactive(
      viewModelBuilder: () => ActivityViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            defaultViewSpacingTop,
            ViewBar(title: localization.activity),
            Expanded(
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
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
                                localization.errorLoadingActivities,
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
                          ? SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.5 / 1,
                                    child: Image.asset(
                                      PngAssetImages.fileCabinet,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Padding(
                                    padding: defaultViewChildPaddingHorizontal,
                                    child: Text(
                                      localization.noChildren, // TODO
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
                            )
                          : !model.hasLogs
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.5 / 1,
                                        child: Image.asset(
                                          PngAssetImages.fileCabinet,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Padding(
                                        padding:
                                            defaultViewChildPaddingHorizontal,
                                        child: Text(
                                          localization.noLog,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      TextButton(
                                        onPressed: model.onAddLog,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              AppIcons.add,
                                              color: textTheme.button.color,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              localization.addLog,
                                              style: textTheme.button, // TODO
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(height: 12),
                                    HorizontalButtonsListView(
                                      itemCount: model.labels.length,
                                      labels: model.labels,
                                      selectedLabelIndex:
                                          model.selectedLabelIndex,
                                      onPressed: model.onLabelPressed,
                                    ),
                                    Expanded(
                                      child: ActivityScrollView(
                                        dates: model.dates,
                                        itemsLoader: model.itemsLoader,
                                        submitedMedLogsLoader:
                                            model.submitedMedLogLoader,
                                        onRefresh: model.onRefresh,
                                      ),
                                    ),
                                  ],
                                ),
            ),
          ],
        ),
      ),
    );
  }
}
