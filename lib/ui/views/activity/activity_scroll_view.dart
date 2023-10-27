import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_item.dart';

import 'package:intl/intl.dart';

class ActivityScrollView extends StatelessWidget {
  final List<DateTime> dates;
  final List<ActivityLogTileItem> Function(DateTime date) itemsLoader;
  final List<ActivityLogTileItem> pastDueLoader;
  final List<ActivityLogTileItem> Function(int month, int year)
      submitedMedLogsLoader;
  final void Function() onRefresh;
  final bool includeDate;
  List<ActivityLogTileItem> get pastDueItems => this.pastDueLoader?.toList();

  const ActivityScrollView({
    Key key,
    @required this.dates,
    @required this.itemsLoader,
    this.includeDate = true,
    this.pastDueLoader,
    this.submitedMedLogsLoader,
    this.onRefresh, // TODO
  })  : assert(dates != null),
        assert(itemsLoader != null),
        assert(includeDate != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return CustomScrollView(
      physics: BouncingScrollPhysics(
        //TODO
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        if (this.onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: this.onRefresh,
          ),
        if (this.pastDueLoader != null && this.pastDueLoader.isNotEmpty)
          SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(localization.pastDue))),
        if (this.pastDueLoader != null && this.pastDueLoader.isNotEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // TODO view model
                  if (pastDueItems[index].pastDue.signingStatus !=
                      SigningStatus.COMPLETED)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ActivityLogTile(
                          activityItem: pastDueItems[index],
                          logType: "pastDue",
                        ),
                      ],
                    );
                  else
                    return SizedBox(height: 1);
                },
                childCount: pastDueLoader.length,
              ),
            ),
          ),
        if (this.dates.isNotEmpty &&
            this.submitedMedLogsLoader(
                    this.dates[0].month, this.dates[0].year) !=
                null &&
            this
                    .submitedMedLogsLoader(
                        this.dates[0].month, this.dates[0].year)
                    .length >
                0)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final DateTime date = this.dates[0]; // TODO view model
                  final String dateMonth = DateFormat.yMMM().format(date);
                  final List<ActivityLogTileItem> activityItems =
                      this.submitedMedLogsLoader(date.month, date.year);
                  if (activityItems.length > 0)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: Text(
                              "Submitted Medlogs " + dateMonth), // TODO util
                        ),
                        SizedBox(height: 14),
                        ...activityItems.map<Widget>((activityItem) {
                          String type = activityItem.logType;
                          return ActivityLogTile(
                            activityItem: activityItem,
                            logType: type,
                          );
                        }),
                      ],
                    );
                  else
                    return SizedBox(height: 1);
                },
                childCount: 1,
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final DateTime date = this.dates[index]; // TODO view model
                final List<ActivityLogTileItem> activityItems =
                    this.itemsLoader(date);
                final bool dateState = true;
                // ((DateTime.now().difference(date).inDays > 0) ||
                //     isSameDay(DateTime.now(), date));
                final now = DateTime.now();
                final tomorrow = DateTime(now.year, now.month, now.day + 1);
                var dateText = isSameDay(now, date)
                    ? localization.today
                    : isSameDay(tomorrow, date)
                        ? localization.tomorrow
                        : "${DateFormat.MMMEd().format(
                            date.toLocal(),
                          )}";
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //if (this.includeDate) ...[
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Text(dateText), // TODO util
                    ),
                    SizedBox(height: 14),
                    //],
                    ...activityItems.map<Widget>((activityItem) {
                      String type = activityItem.logType;
                      if ((dateState || type == "event") &&
                          type != null &&
                          type.isNotEmpty) {
                        return ActivityLogTile(
                          activityItem: activityItem,
                          logType: type,
                        );
                      } else
                        return SizedBox(height: 1);
                    }),
                  ],
                );
              },
              childCount: dates.length,
            ),
          ),
        ),
      ],
    );
  }
}
