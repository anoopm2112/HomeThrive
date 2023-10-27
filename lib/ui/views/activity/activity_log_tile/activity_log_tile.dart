import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_view_model.dart';
import 'package:fostershare/ui/views/activity/activity_log_tile/activity_log_tile_item.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_detail_card.dart';
import 'package:fostershare/ui/widgets/cards/rec_log_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/cards/event_card.dart';
import 'package:fostershare/ui/common/date_format_utils.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ActivityLogTile extends StatelessWidget {
  final ActivityLogTileItem activityItem;
  final String logType;

  const ActivityLogTile({
    Key key,
    @required this.activityItem,
    this.logType,
  })  : assert(activityItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    if (logType == "reclog") {
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => RecLogCard(
                // onCardCreated: () => model.onTileCreated(index),
                onTap: () => model.onRecTap(activityItem.recLog.id),
                image: NetworkImage(
                  activityItem.child.imageURL.toString(),
                ),
                name: (activityItem.child.nickName ??
                    activityItem.child.firstName),
                description: localization.recreationLog,
              ));
    } else if (logType == "medlog") {
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => MedLogCard(
              name:
                  (activityItem.child.nickName ?? activityItem.child.firstName),
              image: NetworkImage(
                activityItem.child.imageURL.toString(),
              ),
              date: activityItem.date,
              description: localization.medLog,
              isSigned: (activityItem.medLog != null &&
                  activityItem.medLog.isSubmitted &&
                  activityItem.medLog.signingStatus != null),
              signPending: activityItem.medLog != null &&
                  activityItem.medLog.signingStatus == SigningStatus.COMPLETED,
              isSubmitted: (activityItem.medLog != null &&
                  activityItem.medLog.signingStatus != null &&
                  activityItem.medLog.signingStatus == SigningStatus.PENDING),
              canSign:
                  activityItem.medLog != null && activityItem.medLog.canSign,
              //onCardCreated: onCreated,
              onTap: () => model.onMedLogTap(activityItem),
              dailyLogSubmitted: activityItem.submitted,
              isCreate: activityItem.medLog == null));
    } else if (logType == "event") {
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => EventCard(
                title: activityItem.events.title,
                description: formattedMMMyTimeRange(
                  startsAt: activityItem.events.startsAt,
                  endsAt: activityItem.events.endsAt,
                ),
                onTap: () => model.onEventDetail(activityItem.events),
              ));
    } else if (logType == "childlog") {
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => ChildLogCard(
                // onCardCreated: () => model.onTileCreated(index),
                onTap: () => model.onTap(this.activityItem),
                image: NetworkImage(
                  activityItem.child.imageURL.toString(),
                ),
                name: (activityItem.child.nickName ??
                    activityItem.child.firstName),
                description: localization.behaviorLog,
                status: activityItem.status,
                //date:activityItem.date,
              ));
    } else if (logType == "pastDue") {
      var date = DateTime(
          activityItem.pastDue.year, activityItem.pastDue.month + 1, 1);
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => MedLogDetailCard(
                // onCardCreated: () => model.onTileCreated(index),
                onTap: () => model.onMedLogDetailsTap(this.activityItem),

                name: (activityItem.child.nickName ??
                    activityItem.child.firstName),
                description: localization.submitMontlyMedLog,
                status: DateFormat.MMMd().format(date),
              ));
    } else if (logType == "submittedMedlog") {
      var date = activityItem.medLog.year != null
          ? DateTime(activityItem.medLog.year, activityItem.medLog.month, 1)
          : activityItem.medLog.createdAt;
      return ViewModelBuilder<ActivityLogTileViewModel>.reactive(
          viewModelBuilder: () => ActivityLogTileViewModel(),
          builder: (context, model, child) => MedLogDetailCard(
              // onCardCreated: () => model.onTileCreated(index),
              onTap: () => model.onSubmittedMedLogDetailsTap(this.activityItem),
              name:
                  (activityItem.child.nickName ?? activityItem.child.firstName),
              description:
                  localization.medLog + " " + DateFormat.yMMM().format(date),
              status: "Submitted",
              type: "completed"));
    }
  }
}
