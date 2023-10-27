import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_log_details/med_log_details_view_model.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/generic_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogDetailsView extends StatelessWidget {
  final medLogId;

  MedLogDetailsView(this.medLogId);

//   @override
//   State<StatefulWidget> createState() => _MedLogDetailsViewState();
// }

// class _MedLogDetailsViewState extends State<MedLogDetailsView> {
  MedLogDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<MedLogDetailsViewModel>.reactive(
        viewModelBuilder: () => MedLogDetailsViewModel(medLogId),
        onModelReady: (model) => model.onModelReady(),
        fireOnModelReadyOnce: false,
        builder: (context, model, child) {
          this.model = model;
          return Scaffold(
            persistentFooterButtons: [
              if (!model.isBusy &&
                  model.canSubmit &&
                  !(model.medLog.isSubmitted &&
                      model.medLog.signingStatus != null))
                MaterialButton(
                  color: theme.accentColor,
                  textColor: theme.buttonColor,
                  visualDensity: VisualDensity.compact,
                  child: Text("Submit"),
                  onPressed: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("Confirm submit"),
                            content: Text(
                                "Make sure to complete all entries for the month before submitting. Once submitted, it cannot be undone."),
                            actions: [
                              MaterialButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              MaterialButton(
                                child: Text("Confirm"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          );
                        });
                    if (result) {
                      await model.onTapSubmit();
                    }
                  },
                ),
              if (!model.isBusy &&
                  model.medLog.isSubmitted &&
                  model.medLog.canSign)
                MaterialButton(
                  color: theme.accentColor,
                  textColor: theme.buttonColor,
                  visualDensity: VisualDensity.compact,
                  child: Text("Sign"),
                  onPressed: () => model.onTapSign(),
                ),
            ],
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => model.onClosePage(),
              ),
              elevation: 0,
              title: Text(
                "Med Log Details", //TODO: Localization
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
                : _scrollableBody(context),
          );
        });
  }

  Widget _scrollableBody(context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          _medLogDetailsList(context),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text("Medications"),
            ),
          ),
          _medicationList(context),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text("Entries"),
            ),
          ),
          _entriesList(context),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: model.isLoadingComplete
                  ? SizedBox()
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryTile(MedLogEntry entry, context) {
    var dateTimeString = "${entry.dateString} ${entry.timeString}";
    return Container(
      child: GenericCard(
        child: Row(
          children: [
            if (!entry.isFailure)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardTextColumn(
                      title: dateTimeString,
                      description: entry.medication.medicationName,
                    ),
                    SizedBox(height: 5),
                    //Row(
                    // children: [
                    // Text(
                    //   "Given: ",
                    //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                    //       fontWeight: FontWeight.w300, fontSize: 12),
                    // ),
                    Text(
                      entry.given,
                      style: Theme.of(context).textTheme.subtitle2,
                      maxLines: 3,
                    ),
                    // ],
                    //),
                    Row(
                      children: [
                        // Text(
                        //   "Entered By: ",
                        //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                        //       fontWeight: FontWeight.w300, fontSize: 12),
                        // ),
                        Text(
                          entry.enteredBy,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            if (entry.isFailure)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CardTextColumn(
                            title: dateTimeString,
                            description: entry.medication.medicationName,
                          ),
                        ),
                        CardTextColumn(
                          titleColor: Colors.red,
                          title: toBeginningOfSentenceCase(
                              describeEnum(entry.failureReason)),
                          description: "",
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.failureDescription,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Text(
                        //   "Entered By: ",
                        //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                        //       fontWeight: FontWeight.w300, fontSize: 12),
                        // ),
                        Text(
                          entry.enteredBy,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            if (!model.medLog.isSubmitted)
              Column(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => model.onTapCreateEntryNote(entry),
                    icon: Icon(
                      entry.notesCount == 0
                          ? Icons.note_add_outlined
                          : Icons.note,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 25),
                  IconButton(
                    onPressed: () async {
                      var result = await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Confirm delete"),
                              content: Text(
                                  "You are about to delete entry for ${entry.medication.medicationName} created on ${entry.dateString} at ${entry.timeString}"),
                              actions: [
                                MaterialButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Confirm"),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            );
                          });
                      if (result) {
                        await model.deleteEntry(entry.id);
                      }
                    },
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _medicationTile(String medicationName, String strength, int notesCount,
      VoidCallback onTapNote, VoidCallback onAddEntry, context) {
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: DetailTile(
        title: null,
        small: true,
        value: medicationName,
        description: strength,
        trailing: Row(
          children: [
            if (!model.medLog.isSubmitted) ...[
              MaterialButton(
                onPressed: onAddEntry,
                // color: theme.accentColor,
                // height: 40,
                // padding: EdgeInsets.only(left: 15, right: 15),
                // visualDensity: VisualDensity.compact,
                // textColor: theme.buttonColor,
                child: Text("Add Entry"),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  notesCount == 0 ? Icons.note_add_outlined : Icons.note,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: onTapNote,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _medicationList(context) {
    var theme = Theme.of(context);
    return SliverList(
      delegate: SliverChildListDelegate([
        ...model.medLog.medications
            .map(
              (e) => _medicationTile(
                  e.medicationName,
                  e.strength,
                  e.notesCount,
                  () => model.onTapCreateMedicationNote(e),
                  () => model.onTapAddEntry(e),
                  context),
            )
            .toList(),
        if (!model.medLog.isSubmitted)
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: MaterialButton(
              color: theme.accentColor,
              textColor: theme.buttonColor,
              visualDensity: VisualDensity.compact,
              child: Text("Add Medication"),
              onPressed: () => model.onTapCreateMedication(),
            ),
          ),
      ]),
    );
  }

  Widget _medLogDetailsList(context) {
    var date = DateTime(model.medLog.year, model.medLog.month);
    var child = model.medLog.child;
    var theme = Theme.of(context);
    return SliverList(
      delegate: SliverChildListDelegate([
        MedLogCard(
          name: DateFormat.yMMMM().format(date),
          image: NetworkImage(child.imageURL),
          description: child.nickName ?? "${child.firstName} ${child.lastName}",
          isSigned: model.medLog.signingStatus == SigningStatus.COMPLETED,
          signPending: (model.medLog.signingStatus != null &&
              model.medLog.signingStatus == SigningStatus.PENDING),
          isSubmitted:
              (model.medLog.isSubmitted && model.medLog.signingStatus != null),
          canSign: model.medLog.canSign,
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 10),
          child: MaterialButton(
            color: theme.accentColor,
            textColor: theme.buttonColor,
            visualDensity: VisualDensity.compact,
            child: Text("More Details"),
            onPressed: () => model.onTapMoreDetails(),
          ),
        )
      ]),
    );
  }

  Widget _entriesList(context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          var entry = model.entries[i];
          var tile = _listTile(
              entry,
              i + 5 == model.entries.length
                  ? () => model.onTileCreated(i)
                  : null,
              context);
          return tile;
        },
        childCount: model.entries.length,
      ),
    );
  }

  Widget _listTile(MedLogEntry entry, Function() onCreated, context) {
    if (onCreated != null) {
      return CreationAwareWidget(
        onWidgetCreated: onCreated,
        child: _entryTile(entry, context),
      );
    } else {
      return _entryTile(entry, context);
    }
  }
}
