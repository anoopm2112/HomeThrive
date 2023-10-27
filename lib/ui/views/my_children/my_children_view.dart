import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/my_children/my_children_log_row.dart';
import 'package:fostershare/ui/views/my_children/my_children_row.dart';
import 'package:fostershare/ui/views/my_children/my_children_view_model.dart';
import 'package:fostershare/ui/widgets/horizontal_buttons_list_view.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class MyChildrenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<MyChildrenViewModel>.reactive(
      viewModelBuilder: () => MyChildrenViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            localization.children,
            style: theme.appBarTheme.titleTextStyle.copyWith(
              fontSize: getResponsiveMediumFontSize(context),
            ),
          ),
        ),
        body: model.isBusy
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.primaryColor,
                  ),
                ),
              )
            : model.hasError || !model.hasChildren
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.hasError
                              ? localization.errorLoadingChildren2
                              : localization.noChildren,
                          textAlign: TextAlign.center,
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
                : Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.dialogBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                // TODO
                                color: Color(0xFFDEE2E7),
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 4),
                              HorizontalButtonsListView(
                                itemCount: model.childrenCount,
                                labels: model.childrenNames,
                                selectedLabelIndex: model.selectedChildIndex,
                                onPressed: model.onChildPressed,
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding:
                                    defaultViewChildPaddingHorizontal.subtract(
                                  EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: model.onAddChildImage,
                                      child: UserAvatar(
                                        radius: 30,
                                        backgroundColor: theme.primaryColor,
                                        image: NetworkImage(
                                          model.selectedChild.imageURL
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 18),
                                    Expanded(
                                      child: Text(
                                        model.selectedChild.firstName,
                                        style: textTheme.headline1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: MyChildrenRow(
                                  label: localization.age,
                                  info: "${model.selectedChild.age}",
                                ),
                              ),
                              Expanded(
                                child: MyChildrenRow(
                                  label: localization.caseManager, // TODO
                                  info: "${model.selectedChild.agentName}",
                                ),
                              ),
                              Expanded(
                                child: MyChildrenRow(
                                  label: localization.totalLogs,
                                  info: "${model.selectedChild.logsCount ?? 0}",
                                ), // TODO remove last border
                              ),
                              Expanded(
                                child: MyChildrenRow(
                                  label: localization.nickName,
                                  info:
                                      "${model.selectedChild.nickName ?? ' '}",
                                  edit: true,
                                  editTap: () => model.onEditNickName(),
                                ), // TODO remove last border
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 11,
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Padding(
                              padding: defaultViewChildPaddingHorizontal.add(
                                EdgeInsets.only(
                                  right: 12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      localization.recentLogs,
                                      style: textTheme.headline1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: getResponsiveMediumFontSize(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: model.onViewAll,
                                    child: Text(
                                      localization.viewAll,
                                      style: textTheme.bodyText2.copyWith(
                                        fontSize: getResponsiveSmallFontSize(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            ...model.selectedChild.recentLogs.map<Widget>(
                              (childLog) => Expanded(
                                child: MyChildrenLogRow(
                                  date: childLog.date,
                                  moodRating: childLog.childMoodRating,
                                  onTap: () => model.onChildLogTap(
                                    childLog,
                                  ),
                                ),
                              ),
                            ),
                            if (model.selectedChild.recentLogs.length != 5)
                              ...List.filled(
                                5 - model.selectedChild.recentLogs.length,
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
