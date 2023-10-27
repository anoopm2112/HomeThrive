import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/generic_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:fostershare/ui/widgets/horizontal_buttons_list_view.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'create_medlog_entry_view_model.dart';

class CreateMedLogEntryView extends StatefulWidget {
  final String medLogId;
  final int medLogYear;
  final int medLogMonth;
  final String medicationId;

  CreateMedLogEntryView(
    this.medLogId,
    this.medLogYear,
    this.medLogMonth,
    this.medicationId,
  );

  @override
  State<StatefulWidget> createState() => _CreateMedLogEntryViewState();
}

class _CreateMedLogEntryViewState extends State<CreateMedLogEntryView> {
  CreateMedLogEntryViewModel model;
  TextEditingController _givenInputController;
  TextEditingController _failureDescriptionController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<CreateMedLogEntryViewModel>.reactive(
      viewModelBuilder: () => CreateMedLogEntryViewModel(
        widget.medLogId,
        widget.medLogYear,
        widget.medLogMonth,
        widget.medicationId,
      ),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Create Entry", //TODO: Localization
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
              : _createEntry(),
        );
      },
    );
  }

  Widget _createEntry() {
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: Text("Create a new entry")),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: _dateField()),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: _timeField()),
                SliverToBoxAdapter(child: SizedBox(height: 30)),
                SliverToBoxAdapter(child: _isSuccessField()),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: _successInput()),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: _failureInput()),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: _createButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _successInput() {
    var isSuccess = model.fieldValue(CreateMedLogEntryInputField.isSuccess);
    if (!isSuccess) {
      return Container();
    }
    return AppTextField(
      labelText: "Given",
      controller: _givenInputController,
      errorText: model.fieldValidationMessage(
        CreateMedLogEntryInputField.given,
      ),
      onChanged: (val) => model.setValue(
        CreateMedLogEntryInputField.given,
        val,
      ),
    );
  }

  Widget _failureInput() {
    var isSuccess = model.fieldValue(CreateMedLogEntryInputField.isSuccess);
    if (isSuccess) {
      return Container();
    }
    return Column(
      children: [
        Text("Choose a reason for failure"),
        SizedBox(height: 5),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: FailureReason.values
              .map(
                (x) => SelectableButton<FailureReason>(
                  selected: x ==
                      model.fieldValue(CreateMedLogEntryInputField.failReason),
                  value: x,
                  onSelected: (val) {
                    model.setValue<FailureReason>(
                      CreateMedLogEntryInputField.failReason,
                      val,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 8,
                    ),
                    child: Text(
                      model.getFailureReasonString(x),
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: getResponsiveSmallFontSize(
                              context,
                            ),
                          ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 10),
        if (!model.validateField(CreateMedLogEntryInputField.failReason))
          Text(
            model
                .fieldValidationMessage(CreateMedLogEntryInputField.failReason),
            style: TextStyle(color: Colors.red),
          ),
        AppTextField(
          labelText: "Description of failure",
          controller: _failureDescriptionController,
          errorText: model.fieldValidationMessage(
            CreateMedLogEntryInputField.failDescription,
          ),
          onChanged: (val) => model.setValue(
            CreateMedLogEntryInputField.failDescription,
            val,
          ),
        )
      ],
    );
  }

  Widget _createButton() {
    var theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: () => model.createEntry(),
          color: theme.accentColor,
          child: Text(
            "Create",
            style: TextStyle(color: theme.buttonColor),
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    var initialDateTime =
        model.fieldValue(CreateMedLogEntryInputField.dateTime);
    var startDateTime = DateTime(widget.medLogYear, widget.medLogMonth);
    var endDateTime = DateTime(widget.medLogYear, widget.medLogMonth + 1, 0);
    var dateString = model.fieldValue(CreateMedLogEntryInputField.dateString);
    return Container(
      child: DetailTile(
        title: "Date",
        value: dateString,
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

  Widget _isSuccessField() {
    var isSuccess = model.fieldValue(CreateMedLogEntryInputField.isSuccess);
    return Column(
      children: [
        Text(
          "Was the medicine successfully administered?",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: "No",
                selected: !isSuccess,
                value: false,
                onSelected: (val) => model.setValue(
                  CreateMedLogEntryInputField.isSuccess,
                  false,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: "Yes",
                selected: isSuccess,
                value: true,
                onSelected: (val) => model.setValue(
                  CreateMedLogEntryInputField.isSuccess,
                  true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _timeField() {
    var theme = Theme.of(context);
    var initialDateTime =
        model.fieldValue(CreateMedLogEntryInputField.dateTime);
    var initialTime = TimeOfDay.fromDateTime(initialDateTime);
    var timeString = model.fieldValue(CreateMedLogEntryInputField.timeString);
    return Container(
      child: DetailTile(
        title: "Time",
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

  @override
  void initState() {
    _givenInputController = TextEditingController();
    _failureDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _givenInputController.dispose();
    _failureDescriptionController.dispose();
    super.dispose();
  }
}
