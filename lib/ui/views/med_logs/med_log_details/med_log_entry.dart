import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view_model.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogEntry extends ViewModelWidget<MedLogSummaryViewModel> {
  MedLogEntry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogSummaryViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    var log = model.selectedMedlogentry;
    var medTitle;
    var administered;
    bool isfailed = false;
    var failurDesc;
    var parent;
    var purpose;
    List<MedLogNote> notes;
    if (log != null) {
      var medName = log.medication?.medicationName;
      var dosage = log.medication?.dosage;
      medTitle =
          medName == null ? localization.noMedication : medName + " " + dosage;
      if (log.isFailure) {
        isfailed = true;
        failurDesc = log.failureDescription ?? "";
        if (log.failureReason != null)
          administered = localization.missed +
              " -" +
              model.getFailureReasonString(log.failureReason);
        else
          administered = "No medication administered";
      } else {
        administered = localization.administered;
      }
      parent = log.enteredBy;
      notes = log.medication?.notes;
      purpose = log.medication != null
          ? log.medication.reason != null
              ? log.medication.reason
              : "--"
          : "--";
    }

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${DateFormat.yMMMMd().format(
                    log.dateTime.toLocal(),
                  )}"),
                ]),
            log != null
                ? Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardTextColumn(
                              title: medTitle,
                              description: administered,
                              verticalSpace: 8,
                            ),
                            SizedBox(height: 20),
                            if (isfailed)
                              CardTextColumn(
                                title: localization.whatHappened,
                                description: failurDesc,
                                verticalSpace: 8,
                              ),
                            SizedBox(height: 10),
                            CardTextColumn(
                              title: localization.loggedBy,
                              description: parent,
                              verticalSpace: 8,
                            ),
                            SizedBox(height: 20),
                            CardTextColumn(
                              title: localization.purpose,
                              description: purpose,
                              verticalSpace: 8,
                            ),
                            SizedBox(height: 20),
                            if (notes != null && notes.isNotEmpty)
                              ...notes.map(
                                (e) => CardTextColumn(
                                  title: localization.medicationNotes,
                                  description: e.content,
                                  verticalSpace: 8,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(localization.noMedication),
          ],
        )
      ],
    );
  }
}
