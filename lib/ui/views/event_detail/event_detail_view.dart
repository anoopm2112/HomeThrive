import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/date_format_utils.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/event_detail/event_detail_view_model.dart';
import 'package:fostershare/ui/views/event_detail/widgets/event_detail_column.dart';
import 'package:fostershare/ui/widgets/sliding_switch.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class EventDetailView extends StatelessWidget {
  final String id;
  final String title;
  final Event eventDetails;

  const EventDetailView({
    Key key,
    @required this.id,
    @required this.title,
    @required this.eventDetails,
  })  : assert(id != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<EventDetailViewModel>.reactive(
      viewModelBuilder: () => EventDetailViewModel(),
      onModelReady: (model) => model.onModelReady(id, eventDetails),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // TODO
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFF95A1AC),
          ),
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            this.title.trim() + "",
            style: TextStyle(
              color: Color(0xFF95A1AC),
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.dialogBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.15),
                            blurRadius: 3,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 2.143,
                            child: Image.network(
                              model.event.image.toString(),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stck) {
                                return Container();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              model.event.description ?? "",
                              style: textTheme.bodyText1,
                            ),
                          ),
                          Divider(
                            color: Color(0xFFDEE2E7),
                            height: 0,
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EventDetailColumn.text(
                                  label: localization.location,
                                  headline: model.event.venue ?? "",
                                  body: model.event.address ?? "",
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xFFDEE2E7), // TODO
                            height: 0,
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EventDetailColumn.text(
                                  label: localization.date,
                                  headline: formattedyMMMd(
                                    model.event.startsAt,
                                  ), // TODO locale
                                ),
                                SizedBox(height: 12),
                                EventDetailColumn.text(
                                  label: localization.time, // TODO locale
                                  headline: formattedTimeRange(
                                    startsAt: model.event.startsAt,
                                    endsAt: model.event.endsAt,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!model.isAgencyEvent(model.event))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: model.busy("UpdatingStatus")
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.primaryColor,
                                          ),
                                        )
                                      : model.event.status ==
                                              EventParticipantStatus.accepted
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      Text(localization.rsvpd),
                                                ),
                                                GestureDetector(
                                                  onTap: model.onAddToCalendar,
                                                  child: Text(
                                                    localization.addToCalendar,
                                                    style: TextStyle(
                                                      color: Color(0xFF8ABAD3),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Text(
                                              localization.willYouAttend,
                                              style: textTheme.bodyText1,
                                            ),
                                ),
                                SizedBox(height: 18),
                                SlidingSwitch(
                                  value: model.fieldValue(
                                            // TODO clean up
                                            EventDetailField.attendance,
                                          ) as EventParticipantStatus ==
                                          EventParticipantStatus.accepted
                                      ? true
                                      : false,
                                  onChanged: (value) =>
                                      model.updateField<EventParticipantStatus>(
                                    EventDetailField.attendance,
                                    value: value
                                        ? EventParticipantStatus.accepted
                                        : EventParticipantStatus.rejected,
                                  ),
                                  textOn: localization.imGoing,
                                  textOff: localization.imNotGoing,
                                  buttonColor: theme.primaryColor,
                                ),
                                // Row(
                                //   children: [
                                //     OutlinedButton(
                                //       // TODO splash color
                                //       style: OutlinedButton.styleFrom(
                                //         side: BorderSide(
                                //           width: 2,
                                //           color: Color(0xFFE6E6E6),
                                //         ),
                                //       ),
                                //       onPressed: () {},
                                //       child: Text(
                                //         No, I'm not,
                                //         style: TextStyle(
                                //           color: Color(0xFF57636C),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 28),
                                //     Expanded(
                                //       child: ElevatedButton(
                                //         onPressed: model.onYesImGoing,
                                //         child: Text(
                                //           Yes, I'm going!,
                                //           style: TextStyle(
                                //             color: AppColors.white,
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
