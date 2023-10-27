import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view_model.dart';
import 'package:fostershare/ui/widgets/cards/medication_card.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogEntrySummary extends ViewModelWidget<MedLogInputViewModel> {
  MedLogEntrySummary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    var date = model.medLog.year != null
        ? DateTime(model.medLog.year, model.medLog.month)
        : model.medLog.createdAt;
    var entryKeys = model.entryKeys ?? null;
    if (entryKeys != null) {
      entryKeys.sort((a, b) {
        return b.compareTo(a);
      });
    }
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Text("${DateFormat.yMMMMd().format(
            //         date.toLocal(),
            //       )}"),
            //     ]),
            model.isBusy
                ? Center(
                    // TODO
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : (model.entries != null && model.entries.isNotEmpty)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.58,
                        child: ListView.separated(
                            itemCount: entryKeys.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var key = entryKeys[index];
                              final List<MedLogEntry> medcine =
                                  model.entries[key];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...[
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      //child: Text(key)
                                      child: Text("${DateFormat.yMMMMd().format(
                                        DateTime.parse(key).toLocal(),
                                      )}"), // TODO util
                                    ),
                                    SizedBox(height: 14),
                                  ],
                                  ...medcine.map<Widget>((medEntry) {
                                    var title = medEntry.medication != null
                                        ? medEntry.medication.medicationName
                                        : localization.noMedication;
                                    title += medEntry.medication != null
                                        ? medEntry.medication.dosage != null
                                            ? ", " + medEntry.medication.dosage
                                            : ''
                                        : '';
                                    var desc;
                                    if (medEntry.isFailure) {
                                      desc = medEntry.failureReason != null
                                          ? model.getFailureReasonString(
                                              medEntry.failureReason)
                                          : localization.notAdministered;
                                    } else {
                                      var time = DateFormat.yMMMMd()
                                          .format(medEntry.dateTime)
                                          .toString();
                                      desc = localization.administeredAt +
                                          " " +
                                          medEntry.timeString;
                                    }

                                    return MedicationCard(
                                      name: title,
                                      description: desc,
                                      onTap: () => {},
                                    );
                                  }),
                                ],
                              );
                            }
                            //   var title = medcine.medication != null
                            //       ? medcine.medication.medicationName
                            //       : "No medicine";
                            //   title += medcine.medication != null
                            //       ? medcine.medication.dosage != null
                            //           ? ", " + medcine.medication.dosage + "mg"
                            //           : ''
                            //       : '';
                            //   var desc = medcine.isFailure
                            //       ? medcine.failureReason != null
                            //           ? model.getFailureReasonString(
                            //               medcine.failureReason)
                            //           : "Not Administered"
                            //       : "Administered at" + medcine.timeString;
                            //   return MedicationCard(
                            //     name: title,
                            //     description: desc,
                            //     onTap: () => model.viewMedLogEntry(medcine),
                            //   );
                            // },
                            ),
                      )
                    : SizedBox(
                        height: (MediaQuery.of(context).size.height + 150) / 2,
                        child: Text(
                          localization.noMedication,
                          style: TextStyle(
                            color: Color(0xFF57636C), // TODO
                          ),
                        ),
                      )
          ],
        ),
      ],
    );
  }
}
