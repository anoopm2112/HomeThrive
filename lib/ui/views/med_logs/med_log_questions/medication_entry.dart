import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationEntry extends ViewModelWidget<MedLogInputViewModel> {
  final String medLogId;
  final int medLogYear;
  final int medLogMonth;
  final String medicationId;
  final DateTime dateTime;
  final String dateString;
  final String timeString;
  final bool earlierDateSelected;
  final void Function(bool selected) onEarlierDateSelected;

  final String errorText;
  MedLogInputViewModel model;
  // TextEditingController _givenInputController;
  // TextEditingController _failureDescriptionController;
  MedicationEntry({
    Key key,
    this.medLogId,
    this.medLogYear,
    this.medLogMonth,
    this.medicationId,
    this.dateString,
    this.dateTime,
    this.timeString,
    this.onEarlierDateSelected,
    this.earlierDateSelected,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    var time = isSameDay(dateTime, DateTime.now()) ? DateTime.now() : dateTime;
    String formattedTodayDate = DateFormat.MMMMEEEEd().format(dateTime);
    String formattedTime = DateFormat.jms().format(time);
    return Column(
      children: [
        TextColumn(
          headline: localization.whenFollowingMedAdministered,
          subheadline:
              "${model.activeMedication.medicationName + ', ' + model.activeMedication.dosage}", //TODO
          error: this.errorText,
        ),
        SizedBox(height: 24),
        Row(
          // TODO put into widget
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.now,
                selected: !(this.earlierDateSelected ?? true),
                value: false,
                onSelected: this.onEarlierDateSelected,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.earlier,
                selected: this.earlierDateSelected ?? false,
                value: true,
                onSelected: this.onEarlierDateSelected,
              ),
            ),
          ],
        ),
        AnimatedCrossFade(
            // TODO look into
            crossFadeState: (this.earlierDateSelected ?? false)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 400),
            firstChild: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  left: 16,
                  right: 16,
                ),
                child: Text(formattedTodayDate),
              ),
              Text(formattedTime)
            ]),
            secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  // Text(
                  //   localization.whatHappened,
                  //   style: Theme.of(context).textTheme.headline1.copyWith(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: getResponsiveMediumFontSize(
                  //           context,
                  //         ),
                  //       ),
                  // ),
                  _dateField(context, model),
                  SizedBox(height: 10),
                  _timeField(context, model),
                  // Expanded(
                  //     child: CustomScrollView(
                  //         slivers: [SliverToBoxAdapter(child: _dateField(context))]))
                ]))
      ],
    );
  }

  // Widget _successInput() {
  //   var isSuccess = model.fieldValue(CreateMedicationInputField.isSuccess);
  //   if (!isSuccess) {
  //     return Container();
  //   }
  //   return AppTextField(
  //     labelText: "Given",
  //     //controller: _givenInputController,
  //     errorText: model.fieldValidationMessage(
  //       CreateMedicationInputField.given,
  //     ),
  //     onChanged: this.onMedGivenChanged,
  //   );
  // }

  Widget _dateField(context, model) {
    var current = DateTime.now();
    var initialDateTime = this.dateTime;
    var startDateTime = DateTime(initialDateTime.year, initialDateTime.month);
    var endDateTime =
        DateTime(initialDateTime.year, initialDateTime.month + 1, 0);
    final localization = AppLocalizations.of(context);
    return Container(
      child: DetailTile(
        title: localization.date,
        value: this.dateString,
        trailing: Icon(Icons.calendar_today),
        trailingAction: () async {
          var newDate = await showDatePicker(
            context: context,
            initialDate: initialDateTime,
            firstDate: startDateTime,
            lastDate: endDateTime,
            builder: (ctx, child) => Theme(
              data: ThemeData(),
              child: child,
            ),
          );
          if (newDate != null) {
            model.setDate(newDate);
          }
        },
      ),
    );
  }

  Widget _timeField(context, model) {
    var time = isSameDay(dateTime, DateTime.now()) ? DateTime.now() : dateTime;
    var theme = Theme.of(context);
    var initialDateTime = this.dateTime;
    var initialTime = TimeOfDay.fromDateTime(initialDateTime);
    var timeString = this.timeString;
    final localization = AppLocalizations.of(context);
    return Container(
      child: DetailTile(
        title: localization.time,
        value: timeString,
        trailing: Icon(Icons.access_time),
        trailingAction: () async {
          var newTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
            builder: (ctx, child) => Theme(
              data: ThemeData(),
              child: child,
            ),
          );
          if (newTime != null) {
            model.setTime(newTime);
          }
        },
      ),
    );
  }

  // @override
  // void initState() {
  //   _givenInputController = TextEditingController();
  //   _failureDescriptionController = TextEditingController();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _givenInputController.dispose();
  //   _failureDescriptionController.dispose();
  //   super.dispose();
  // }
}
