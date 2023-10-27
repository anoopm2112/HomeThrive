import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_details/med_log_entry.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/create_medication.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/med_log_entry_summary.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/medications.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/medication_entry.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/med_log_submit.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/missed_medications.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/missed_medications_reason.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogInputView extends StatelessWidget {
  final DateTime date;
  final Child child;
  final MedLog medLog;
  final String secondaryAuthorId;
  final void Function(MedLog medLog) onMedLogChanged;

  const MedLogInputView({
    Key key,
    @required this.date,
    @required this.child,
    this.medLog,
    this.secondaryAuthorId, // TODO secondary Auth ID
    this.onMedLogChanged, // TODO asserts
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MedLogInputViewModel>.reactive(
        viewModelBuilder: () => MedLogInputViewModel(
              localization: AppLocalizations.of(context),
              date: this.date,
              child: this.child,
              medLog: this.medLog,
              onComplete: this.onMedLogChanged,
            ),
        builder: (context, model, child) {
          final localization = AppLocalizations.of(context);
          final textTheme = Theme.of(context).textTheme;
          final theme = Theme.of(context);

          final String childname = this.child.nickName ?? this.child.firstName;
          bool nonDetailScreens = false;
          String mainTitle = "";
          String subTitle = "";
          if (MedLogInputState.selectMedication == model.state) {
            nonDetailScreens = true;
            mainTitle = "${childname + "'s " + localization.medLog}";
            subTitle = localization.selectAllMedicationAdministred;
          } else if (MedLogInputState.newMedication == model.state) {
            nonDetailScreens = true;
            mainTitle = localization.addNewMedication;
            subTitle = "${localization.medicationOf + " " + childname}";
          }

          return Scaffold(
              backgroundColor: theme.dialogBackgroundColor,
              persistentFooterButtons: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    children: [
                      if (model.state.index != 0 &&
                          model.state != MedLogInputState.medLogEntryDetails)
                        OutlinedButton(
                          // TODO make into widget
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Color(0xFFE6E6E6),
                            ),
                          ),
                          onPressed:
                              model.state == MedLogInputState.newMedication
                                  ? model.onNewMedClose
                                  : model.onPrevious,
                          child: Text(
                            localization.previous,
                            style: TextStyle(
                              color: Color(0xFF57636C), // TODO
                            ),
                          ),
                        ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      ElevatedButton(
                        onPressed: model.isBusy
                            ? null
                            : (model.state ==
                                    MedLogInputState.medLogEntryDetails
                                ? model.addMoreMedication
                                : model.state == MedLogInputState.newMedication
                                    ? model.newMedication
                                    : model.onNext),
                        child: model.isBusy
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).dialogBackgroundColor,
                                ),
                              )
                            : Text(
                                (model.state ==
                                        MedLogInputState.medLogEntryDetails)
                                    ? localization.addMoreLogs
                                    : (model.state ==
                                            MedLogInputState.medLogSubmit)
                                        ? localization.submit
                                        : (model.state ==
                                                MedLogInputState.newMedication
                                            ? localization.add
                                            : localization.next),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 16,
                      right: 16,
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: model.onBack,
                              child: Icon(
                                Icons.close,
                                size: 32,
                                color: Color(0xFF95A1AC), // TODO
                              ),
                            ),
                            Text(nonDetailScreens
                                ? ""
                                : "${DateFormat.MMMEd().format(
                                    this.date.toLocal(),
                                  )}"),
                          ],
                        ),
                        nonDetailScreens
                            ? Column(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    children: [
                                      Text(
                                        mainTitle,
                                        style: textTheme.headline1.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: getResponsiveLargeFontSize(
                                              context),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(subTitle),
                                    ],
                                  ),
                                ),
                              ])
                            : Center(
                                child: Column(
                                  children: [
                                    // UserAvatar(
                                    //   image: NetworkImage(this.child.imageURL.toString()),
                                    //   radius: 45,
                                    // ),
                                    Container(
                                      child: Image.asset(
                                        PngAssetImages.medLog,
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(this.child.nickName ??
                                        this.child.firstName),
                                    SizedBox(height: 3),
                                    Text(localization.medLog),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Divider(
                    height: 0,
                    color: Color(0xFFDEE2E7), // TODO
                    thickness: 1,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: model.state !=
                              MedLogInputState
                                  .medLogSubmit // TODO put into model
                          ? EdgeInsets.only(
                              left: 16,
                              top: 16,
                              right: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              // bottom: 16,
                            )
                          : EdgeInsets.only(
                              bottom: 16,
                            ),
                      child: Column(
                        children: [
                          _getViewForState(model),
                          SizedBox(height: 28),
                          // if (model.state != MedLogInputState.newMedication)
                          //   AnimatedSmoothIndicator(
                          //     activeIndex: model.activeIndex,
                          //     count: 3,
                          //     effect: WormEffect(
                          //       dotWidth: 20,
                          //       dotHeight: 10,
                          //       radius: 5,
                          //       activeDotColor: Theme.of(context).primaryColor,
                          //       dotColor: Color(0xFFDBE2E7), // TODO
                          //     ),
                          //   ),
                          // SizedBox(height: 20),

                          /*Padding(
                            padding: model.state ==
                                    MedLogInputState
                                        .medLogSubmit // TODO put into model
                                ? EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  )
                                : EdgeInsets.only(bottom: 25),
                            child: Row(
                              children: [
                                if (model.state.index != 0 &&
                                    model.state !=
                                        MedLogInputState.medLogEntryDetails)
                                  OutlinedButton(
                                    // TODO make into widget
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xFFE6E6E6),
                                      ),
                                    ),
                                    onPressed: model.state ==
                                            MedLogInputState.newMedication
                                        ? model.onNewMedClose
                                        : model.onPrevious,
                                    child: Text(
                                      localization.previous,
                                      style: TextStyle(
                                        color: Color(0xFF57636C), // TODO
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                ElevatedButton(
                                  onPressed: model.isBusy
                                      ? null
                                      : (model.state ==
                                              MedLogInputState
                                                  .medLogEntryDetails
                                          ? model.addMoreMedication
                                          : model.state ==
                                                  MedLogInputState.newMedication
                                              ? model.newMedication
                                              : model.onNext),
                                  child: model.isBusy
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .dialogBackgroundColor,
                                          ),
                                        )
                                      : Text(
                                          (model.state ==
                                                  MedLogInputState
                                                      .medLogEntryDetails)
                                              ? localization.addMoreLogs
                                              : (model.state ==
                                                      MedLogInputState
                                                          .medLogSubmit)
                                                  ? localization.submit
                                                  : (model.state ==
                                                          MedLogInputState
                                                              .newMedication
                                                      ? localization.add
                                                      : localization.nextStep),
                                        ),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Widget _getViewForState(MedLogInputViewModel model) {
    assert(model != null);

    switch (model.state) {
      case MedLogInputState.medicationEntry:
        return MedicationEntry(
          dateTime: model.fieldValue<DateTime>(
            CreateMedicationInputField.dateTime,
          ),
          dateString: model.fieldValue<String>(
            CreateMedicationInputField.dateString,
          ),
          timeString: model.fieldValue<String>(
            CreateMedicationInputField.timeString,
          ),
          earlierDateSelected: model.fieldValue(
            CreateMedicationInputField.hasEarlierDate,
          ) as bool,
          onEarlierDateSelected: (earlier) => model.updateField<bool>(
            CreateMedicationInputField.hasEarlierDate,
            value: earlier,
          ),
        );
      case MedLogInputState.newMedication:
        return CreateMedication(
          medName: model.fieldValue<String>(
            CreateMedicationInputField.name,
          ),
          dosage: model.fieldValue<String>(
            CreateMedicationInputField.dosage,
          ),
          reason: model.fieldValue<String>(
            CreateMedicationInputField.reason,
          ),
          physicianName: model.fieldValue<String>(
            CreateMedicationInputField.physicianName,
          ),
          notes: model.fieldValue<String>(
            CreateMedicationInputField.notes,
          ),
          onMedNameChanged: (name) => model.updateField<String>(
            CreateMedicationInputField.name,
            value: name,
          ),
          onDosageChanged: (dosage) => model.updateField<String>(
            CreateMedicationInputField.dosage,
            value: dosage,
          ),
          onStrengthChanged: (strength) => model.updateField<String>(
            CreateMedicationInputField.strength,
            value: strength,
          ),
          onReasonChanged: (reason) => model.updateField<String>(
            CreateMedicationInputField.reason,
            value: reason,
          ),
          onPhysicianNameChanged: (physician) => model.updateField<String>(
            CreateMedicationInputField.physicianName,
            value: physician,
          ),
          onNotesChanged: (notes) => model.updateField<String>(
            CreateMedicationInputField.notes,
            value: notes,
          ),
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.name,
          ),
        );
      case MedLogInputState.medLogSubmit:
        return MedLogSubmit(
            onMedLogChecked: (chk) => model.onMedLogChecked(chk));
      case MedLogInputState.missedMedicine:
        return MissedMedications(
          isSuccess: model.fieldValue(
            CreateMedicationInputField.isMedicationMissed,
          ) as bool,
          onMedicationSuccessSelected: (sucess) => model.updateField<bool>(
            CreateMedicationInputField.isMedicationMissed,
            value: sucess,
          ),
        );
      case MedLogInputState.missedMedicationReason:
        return MissedMedicationReason(
          failureReason: model.fieldValue(
            CreateMedicationInputField.failReason,
          ) as FailureReason,
          failureDescription: model.fieldValue(
            CreateMedicationInputField.failDescription,
          ) as String,
          onReasonSelected: (reason) => model.updateField<FailureReason>(
            CreateMedicationInputField.failReason,
            value: reason,
          ),
          onDescriptionChanged: (reason) => model.updateField<String>(
            CreateMedicationInputField.failDescription,
            value: reason,
          ),
        );
      case MedLogInputState.medLogEntryDetails:
        return MedLogEntrySummary();
      case MedLogInputState.selectMissedMedication:
        return Medications(
            selectedMedications: model.fieldValue(
              CreateMedicationInputField.medications,
            ) as List,
            selectNoneAdministered: model.noneAdministered,
            onMedicationSelected: (medicine) {
              model.updateMedicationField(
                medication: medicine,
              );
            },
            onNonAdministeredSelected: (medicine) {
              model.updateNonAdminsteredField();
            });
      case MedLogInputState.selectMedication:
      default:
        return Medications(
            selectedMedications: model.fieldValue(
              CreateMedicationInputField.medications,
            ) as List,
            selectNoneAdministered: model.noneAdministered,
            onMedicationSelected: (medicine) {
              model.updateMedicationField(
                medication: medicine,
              );
            },
            onNonAdministeredSelected: (medicine) {
              model.updateNonAdminsteredField();
            });
    }
  }
}
