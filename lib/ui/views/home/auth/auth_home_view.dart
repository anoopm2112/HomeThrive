import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/common/date_format_utils.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/activity/activity_scroll_view.dart';
import 'package:fostershare/ui/views/activity/activity_view_model.dart';
import 'package:fostershare/ui/views/home/auth/auth_home_view_model.dart';
import 'package:fostershare/ui/widgets/cards/med_log_detail_card.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

class AuthHomeView extends StatefulWidget {
  @override
  _AuthHomeViewState createState() => _AuthHomeViewState();
}

class _AuthHomeViewState extends State<AuthHomeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ViewModelBuilder<AuthHomeViewModel>.reactive(
      viewModelBuilder: () => locator<AuthHomeViewModel>(),
      onModelReady: (model) => model.onModelReady(),
      disposeViewModel: false,
      fireOnModelReadyOnce: false,
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              children: [
                SizedBox(height: 4),
                // SlidingSwitch(
                //   value:
                //       model.calendarMode == CalendarMode.events ? false : true,
                //   onChanged: model.onSwitchToggle,
                //   height: 32, // TODO
                //   width: 229, // TODO
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TableCalendar<dynamic>(
                    firstDay: DateTime.utc(2010, 10, 16), // TODO dynamic?
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: model.focusedDay,
                    pageJumpingEnabled: true,

                    // TODO pass locale

                    rowHeight: 44, // TODO fix percentage width?
                    selectedDayPredicate: (day) => day == model.selectedDay,
                    // eventLoader: model.calendarMode == CalendarMode.events
                    //     ? model.eventLoader
                    //     : null,
//                        : (date) => model.itemsLoader(date.toLocal()),
                    eventLoader: model.eventLoader,
                    onDaySelected: model.onDaySelected,
                    onPageChanged: model.onPageChanged,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    headerStyle: HeaderStyle(
                      titleTextFormatter: (date, locale) =>
                          DateFormat.MMMM(locale).format(date),
                      titleCentered: true,
                      formatButtonVisible: false,
                      headerPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      ),
                      leftChevronPadding: EdgeInsets.zero,
                      leftChevronMargin: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      rightChevronMargin: EdgeInsets.zero,
                      leftChevronIcon: Icon(
                        AppIcons.chevronLeft,
                        color: Color(0xFF95A1AC),
                      ),
                      rightChevronIcon: Icon(
                        AppIcons.chevronRight,
                        color: Color(0xFF95A1AC),
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextFormatter: (date, locale) =>
                          DateFormat.E(locale).format(date).toUpperCase(),
                      weekdayStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF10233D), // TODO
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF10233D),
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      markersAutoAligned: false,
                      markersOffset: PositionedOffset(
                        bottom: 8,
                      ),
                      cellMargin: EdgeInsets.zero,
                      defaultDecoration: null,
                      defaultTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF768294),
                        height: 1.4,
                      ),
                      todayTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF768294),
                        height: 1.4,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFF1F4F8),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                        height: 1.4,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF242424).withOpacity(.2),
                            offset: Offset(0, 2),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      weekendTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF768294),
                        height: 1.4,
                      ),
                      weekendDecoration: null,
                      outsideTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBAC3D2),
                        height: 1.4,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: null,
                      //model.calendarMode == CalendarMode.events
                      //? null
                      //: (context, date, events) {
                      // final List<ActivityLogTileItem> items =
                      //     model.itemsLoader(date);

                      // final bool allSubmitted =
                      //     items.every((item) => item.submitted);
                      // final bool oneInProgress = items.any((item) =>
                      //     item.status == ChildLogStatus.incomplete ||
                      //     item.submitted);

                      //return Container();
                      // return Container(
                      //   width: 6,
                      //   height: 6,
                      //   margin:
                      //       const EdgeInsets.symmetric(horizontal: 1),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: allSubmitted
                      //         ? Colors.green
                      //         : oneInProgress
                      //             ? Colors.orange
                      //             : Colors.red,
                      //     // date == model.selectedDay
                      //     //     ? theme.dialogBackgroundColor
                      //     //     : theme.primaryColor,
                      //   ),
                      // );
                      //},
                      singleMarkerBuilder: (context, date, event) {
                        // final bool activityMode =
                        //     model.calendarMode == CalendarMode.activity;
                        // ActivityLogTileItem item;
                        // if (activityMode) {
                        //   item = event as ActivityLogTileItem;
                        // }

                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: date == model.selectedDay
                                ? theme.dialogBackgroundColor
                                : theme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Padding(
          //   padding: defaultViewPaddingHorizontal,
          //   child: Text(
          //     model.pastDueLoader() != null
          //         ? "Past Due"
          //         : model.showEventsForMonth
          //             ? DateFormat(DateFormat.MONTH).format(model.focusedDay)
          //             : DateFormat(DateFormat.YEAR_MONTH_DAY)
          //                 .format(model.selectedDay),
          //   ),
          // ),
          Expanded(
            // TODO error state/ pull to refresh
            child: model.isBusy
                ? Center(
                    // TODO
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : model.calendarMode == CalendarMode.activity
                    ? ActivityScrollView(
                        dates: model.hasChildren
                            ? model.showEventsForMonth
                                ? getDaysInBetween(
                                    DateTime(model.focusedDay.year,
                                        model.focusedDay.month, 1),
                                    DateTime(model.focusedDay.year,
                                        model.focusedDay.month + 1, 0),
                                  )
                                    .where((date) =>
                                        DateTime.now()
                                            .difference(date)
                                            .inDays >=
                                        0)
                                    .toList()
                                    .reversed
                                    .toList()
                                // : [model.focusedDay.toLocal()]
                                :
                                //if (
                                // DateTime.now()
                                //           .difference(model.focusedDay)
                                //           .inDays >
                                //       0 ||
                                //isSameDay(DateTime.now(), model.focusedDay))
                                isSameDay(DateTime.now(), model.focusedDay)
                                    ? getDaysInBetween(
                                        DateTime(
                                            model.focusedDay.year,
                                            model.focusedDay.month,
                                            model.focusedDay.day),
                                        DateTime(
                                            model.focusedDay.year,
                                            model.focusedDay.month,
                                            model.focusedDay.day + 1),
                                      )
                                        .where((date) =>
                                            DateTime.now()
                                                .difference(date)
                                                .inDays >=
                                            0)
                                        .toList()
                                        .reversed
                                        .toList()
                                    : [
                                        DateTime(
                                          model.focusedDay.year,
                                          model.focusedDay.month,
                                          model.focusedDay.day,
                                        )
                                      ]
                            : [],
                        itemsLoader: model.itemsLoader,
                        submitedMedLogsLoader: model.submitedMedLogLoader,
                        pastDueLoader: model.pastDueLoader(),
                        includeDate: model.showEventsForMonth,
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: model.eventsList
                              .map<Widget>(
                                (event) => GestureDetector(
                                  onTap: () => model.onEventDetail(event),
                                  child: Card(
                                    // TODO make into a widget
                                    margin: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 10,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        top: 20,
                                        right: 20,
                                        bottom: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3
                                                      .copyWith(fontSize: 16),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  formattedMMMyTimeRange(
                                                    startsAt: event.startsAt,
                                                    endsAt: event.endsAt,
                                                  ), // TODO put into util and ue locale
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: ShapeDecoration(
                                              // color: Colors.red,
                                              shape: CircleBorder(
                                                side: BorderSide(
                                                  width: 2,
                                                  color: Color(0xFF8ABAD3),
                                                ),
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                PngAssetImages.resourceCarousel,
                                              ), // TODO switch to network
                                              radius: 15,
                                            ),
                                          ),
                                          Icon(Icons.chevron_right), // TODO
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _medLogsList(model) {
    return CustomScrollView(
        physics: BouncingScrollPhysics(
          //TODO
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  var log = model.logs[i];
                  var tile = _listTile(
                    log.month,
                    log.year,
                    log.child.nickName ??
                        "${log.child.firstName} ${log.child.lastName}",
                    i + 5 == model.logs.length
                        ? () => model.onTileCreated(i)
                        : null,
                    () => model.onTapMedLog(log),
                  );
                  return tile;
                },
                childCount: model.logs.length,
              )))
        ]);
  }

  Widget _listTile(
    int month,
    int year,
    String childName,
    Function() onCreated,
    VoidCallback onTap,
  ) {
    var date = DateTime(year, month + 1, 1);
    return MedLogDetailCard(
      name: childName,
      description: "Submit monthly med log",
      onCardCreated: onCreated,
      onTap: onTap,
      status: DateFormat.Md().format(date),
    );
  }
}
