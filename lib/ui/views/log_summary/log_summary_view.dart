import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/log_summary/log_summary_view_model.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:fostershare/ui/widgets/child_log_row.dart';
import 'package:fostershare/ui/widgets/log_column.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class LogSummaryView extends StatelessWidget {
  final String id;
  final DateTime date;
  final Child child;
  final ChildLog childLog;
  final ChildLogStatus status;

  const LogSummaryView({
    Key key,
    this.id,
    this.childLog,
    @required this.date,
    @required this.child,
    this.status = ChildLogStatus.submitted,
  })  : assert(id != null ||
            childLog != null && !(id != null && childLog != null)),
        assert(date != null),
        assert(child != null),
        assert(status != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<LogSummaryViewModel>.reactive(
      viewModelBuilder: () => LogSummaryViewModel(
        childLog: this.childLog,
        status: this.status,
      ),
      onModelReady: (model) => model.onModelReady(id),
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onWillPopScope,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              // TODO
              "${DateFormat.MMMEd().format(
                date.toLocal(),
              )}",
              style: theme.appBarTheme.titleTextStyle.copyWith(
                fontSize: getResponsiveMediumFontSize(
                  context,
                ),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 12,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.appBarTheme.color,
                  boxShadow: [
                    BoxShadow(
                      // TODO
                      color: Color(0xFFDEE2E7),
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ChildLogRow(
                  image: NetworkImage(
                    this.child.imageURL.toString(),
                  ),
                  name: this.child.nickName ?? this.child.firstName,
                  description: "${this.child.age}", // TODO fix
                  status: model.status,
                  showTrail: model.status == ChildLogStatus.submitted,
                ),
              ),
              if (model.isBusy)
                Expanded(
                  child: Center(
                    // TODO
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  if (model.canEdit) ...[
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(localization.tapItemEdit),
                                      ],
                                    ),
                                  ],
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF242424)
                                              .withOpacity(.20),
                                          offset: Offset(0, 2),
                                          blurRadius: 7,
                                        ),
                                      ],
                                    ),
                                    child: LogColumn(
                                      dayRating: model.childLog.dayRating,
                                      dayRatingComments:
                                          model.childLog.dayRatingComments,
                                      onTapDayRating: model.onTapDayRating,
                                      parentMoodRating:
                                          model.childLog.parentMoodRating,
                                      parentMoodComments:
                                          model.childLog.parentMoodComments,
                                      onTapParentMood: model.onTapParentMood,
                                      behavioral:
                                          model.childLog.behavioralIssues,
                                      behavioralComments: model
                                          .childLog.behavioralIssuesComments,
                                      onTapBehavioral: model.onTapDayBehavioral,
                                      familyVisit: model
                                          .childLog.familyVisit, // TODO finish
                                      familyVisitComments:
                                          model.childLog.familyVisitComments,
                                      onTapFamilyVisit:
                                          model.onTapBioFamilyVisit,
                                      childMoodRating:
                                          model.childLog.childMoodRating,
                                      childMoodComments:
                                          model.childLog.childMoodComments,
                                      onTapChildMood: model.onTapChildMood,
                                      medicationChange:
                                          model.childLog.medicationChange,
                                      medicationChangeComments: model
                                          .childLog.medicationChangeComments,
                                      onTapMedicationChange:
                                          model.onTapChildMedication,
                                    ),
                                  ),
                                  if (this.status ==
                                      ChildLogStatus.submitted) ...[
                                    SizedBox(height: 18),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(localization.notes),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (model.status == ChildLogStatus.submitted &&
                              (model.childLog.notes == null ||
                                  model.childLog.notes.isEmpty))
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(localization.noNotesAdded),
                                  ],
                                ),
                              ),
                            )
                          else if (model.status ==
                              ChildLogStatus.submitted) ...[
                            SliverToBoxAdapter(
                              child: SizedBox(height: 20),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFDEE2E7),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        model.childLog.notes[index].text.trim(),
                                        style: textTheme.headline3.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: getResponsiveSmallFontSize(
                                              context),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      // TODO
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${DateFormat.yMMMd().format(model.childLog.notes[index].createdAt.toLocal())} ${DateFormat(DateFormat.HOUR_MINUTE).format(model.childLog.notes[index].createdAt.toLocal())}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                childCount: model.childLog.notes.length,
                              ),
                            ),
                          ] else
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 24),
                                  Center(
                                    child: TextButton(
                                      onPressed: model.onCompleteLog,
                                      child: Text(
                                        localization.completeLog,
                                        style: textTheme.button,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: model.status == ChildLogStatus.submitted
                                  ? 140
                                  : 20,
                            ),
                          ),
                        ],
                      ),
                      if (model.status == ChildLogStatus.submitted)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(.15),
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: model.onAddNote,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text(localization.addNote),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 0,
                                ),
                                SizedBox(height: 34),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
