import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log/child_sex_enum.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/generic_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:fostershare/ui/widgets/horizontal_buttons_list_view.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'create_med_log_view_model.dart';

class CreateMedLogView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateMedLogViewState();
}

class _CreateMedLogViewState extends State<CreateMedLogView> {
  CreateMedLogViewModel model;
  TextEditingController medicationNameController;
  TextEditingController medicationReasonController;
  TextEditingController medicationDosageController;
  TextEditingController medicationStrengthController;
  TextEditingController physicianNameController;
  String prescriptionDateString;
  DateTime prescriptionDate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<CreateMedLogViewModel>.reactive(
      viewModelBuilder: () => CreateMedLogViewModel(),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Med Log", //TODO: Localization
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
              : model.fieldValue(CreateMedLogInputField.child) == null
                  ? _medLogsList()
                  : model.isReviewMode
                      ? _reviewPage()
                      : _medLogInputsList(),
        );
      },
    );
  }

  Widget _medLogInputsList() {
    var theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _selectedMedLogCard(),
              _childSexSelection(),
              _allergiesInput(),
              _medicationSelection(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(10),
            child: MaterialButton(
              onPressed: model.getOnTapReview(),
              color: theme.accentColor,
              child: Text(
                "Review",
                style: TextStyle(color: theme.buttonColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectedMedLogCard() {
    var date = DateTime(
      model.fieldValue(CreateMedLogInputField.year),
      model.fieldValue(CreateMedLogInputField.month),
    );
    var child = model.fieldValue(CreateMedLogInputField.child);
    return MedLogCard(
      image: NetworkImage(child.imageURL),
      name: DateFormat.yMMMM().format(date),
      description: child.nickName ?? "${child.firstName} ${child.lastName}",
    );
  }

  Widget _medLogsList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text("Tap on a med log to add it"),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, i) {
              var log = model.availableLogsToCreate[i];
              var tile = _listTile(
                log.month,
                log.year,
                log.child.nickName ??
                    "${log.child.firstName} ${log.child.lastName}",
                log.child.imageURL,
                onTap: () => model.selectLogForCreation(log),
              );
              return tile;
            },
            itemCount: model.availableLogsToCreate.length,
          ),
        ),
      ],
    );
  }

  Widget _childSexSelection() {
    var theme = Theme.of(context);
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text("Select child sex"),
      ), //TODO: Localize
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: ChildSex.values
            .map(
              (x) => SelectableButton<ChildSex>(
                selected: x == model.fieldValue(CreateMedLogInputField.sex),
                value: x,
                onSelected: (val) {
                  model.setValue<ChildSex>(
                    CreateMedLogInputField.sex,
                    val,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    model.getChildSexString(x),
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
      if (!model.validateField(CreateMedLogInputField.sex))
        Text(
          model.fieldValidationMessage(CreateMedLogInputField.sex),
          style: TextStyle(color: Colors.red),
        )
    ]);
  }

  Widget _medicationSelection() {
    var theme = Theme.of(context);
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text("Medications"),
      ),
      _suggestedMedications(),
      _createMedicationForm() //TODO: Localize
    ]);
  }

  Widget _suggestedMedications() {
    if (model.suggestedMedications == null ||
        model.suggestedMedications.isEmpty) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Tap + to add a medication:",
            ),
          ),
          ...model.suggestedMedications
              .map((med) => _medicationSelectionTile(med))
              .toList(),
        ],
      ),
    );
  }

  Widget _allergiesInput() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Allergies"),
          SizedBox(height: 10),
          AppTextField(
            labelText: "Allergies",
            initialText: model.fieldValue(CreateMedLogInputField.allergies),
            onChanged: (allergies) => model.setValue<String>(
              CreateMedLogInputField.allergies,
              allergies,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewPage() {
    var theme = Theme.of(context);
    var childSex = model.fieldValue(CreateMedLogInputField.sex);
    var allergies = model.fieldValue(CreateMedLogInputField.allergies) ?? "-";
    var medications =
        model.fieldValue(CreateMedLogInputField.medications) ?? [];
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _selectedMedLogCard(),
              DetailTile(
                title: "Child Sex",
                value: model.getChildSexString(childSex),
              ),
              DetailTile(
                title: "Allergies",
                value: allergies,
              ),
              SizedBox(height: 10),
              if (medications.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Medications"),
                ),
              if (medications.isNotEmpty)
                ...medications.map(
                  (x) => Container(
                    margin: EdgeInsets.all(10),
                    child: _medicationSelectionTile(
                      x,
                      allowSelection: false,
                    ),
                  ),
                )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              TextButton(
                onPressed: () => model.setReviewMode(false),
                child: Text(
                  "Back",
                  style: TextStyle(color: theme.buttonColor),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => model.createMedLog(),
                child: Text(
                  "Create",
                  style: TextStyle(color: theme.buttonColor),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _medicationSelectionTile(MedLogMedicationDetail medication,
      {bool allowSelection = true}) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Container(
      // decoration: BoxDecoration(
      //   //border: Border.all(color: Colors.grey),
      //   borderRadius: BorderRadius.all(Radius.circular(10)),
      //   color: Colors.white,
      // ),
      // padding: EdgeInsets.only(left: 10, bottom: 5),
      child: GenericCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          medication.medicationName,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headline1.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          medication.strength,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyText1.copyWith(
                            color: theme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Dosage: ${medication.dosage}",
                          style: textTheme.headline1.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Reason: ${medication.reason}",
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headline1.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (medication.physicianName != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Physician: ${medication.physicianName}",
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headline1.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (medication.prescriptionDateString != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Prescription Date: ${medication.prescriptionDateString}",
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headline1.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (allowSelection)
              IconButton(
                onPressed: () => _onAddMedication(medication),
                icon: Icon(
                  (model.fieldValue(CreateMedLogInputField.medications) ?? [])
                          .any((x) => x == medication)
                      ? Icons.cancel_outlined
                      : Icons.add,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _onAddMedication(MedLogMedicationDetail medication) {
    List<MedLogMedicationDetail> medications =
        model.fieldValue(CreateMedLogInputField.medications) ?? [];
    var exist = medications.any((x) => x == medication);
    if (exist) {
      medications = medications.where((x) => x != medication).toList();
    } else {
      medications.add(medication);
    }
    model.setValue<List<MedLogMedicationDetail>>(
        CreateMedLogInputField.medications, medications);
  }

  Widget _createMedicationForm() {
    var theme = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text("Create a new medication:"),
              ),
              AppTextField(
                labelText: "Medication Name",
                controller: medicationNameController,
                textInputAction: TextInputAction.next,
              ),
              AppTextField(
                labelText: "Reason",
                controller: medicationReasonController,
                textInputAction: TextInputAction.next,
              ),
              AppTextField(
                labelText: "Dosage",
                controller: medicationDosageController,
                textInputAction: TextInputAction.next,
              ),
              AppTextField(
                labelText: "Strength",
                controller: medicationStrengthController,
                textInputAction: TextInputAction.next,
              ),
              AppTextField(
                labelText: "Physician Name",
                controller: physicianNameController,
              ),
              _dateField(),
              SizedBox(height: 5),
              if (!_isCreateMedFormValid())
                Text("First 4 fields are mandatory",
                    style: TextStyle(color: Colors.red)),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: _submitMedication,
                  child: Icon(
                    Icons.add,
                    color: theme.buttonColor,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _dateField() {
    var initialDateTime = DateTime.now();
    var startDateTime = DateTime(initialDateTime.year - 20, 1);
    var endDateTime = DateTime(initialDateTime.year + 1, 1);
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: DetailTile(
        title: "Prescription Date",
        value: prescriptionDateString,
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
            var dateString = DateFormat.yMMMMd().format(newDate);
            prescriptionDate = newDate;
            prescriptionDateString = dateString;
          } else {
            prescriptionDateString = null;
            prescriptionDate = null;
          }
          setState(() {});
        },
      ),
    );
  }

  bool _isCreateMedFormValid() {
    var vals = [
      medicationNameController.text.trim(),
      medicationReasonController.text.trim(),
      medicationDosageController.text.trim(),
      medicationStrengthController.text.trim(),
    ];
    var anyNull = vals.any((element) => element == null);
    var anyEmpty = vals.any((element) => element.isEmpty);

    if (anyNull || anyEmpty) {
      return false;
    }
    return true;
  }

  _submitMedication() {
    if (!_isCreateMedFormValid()) {
      setState(() {});
      return;
    }
    var medName = medicationNameController.text;
    var medReason = medicationReasonController.text;
    var medDosage = medicationDosageController.text;
    var medStrength = medicationStrengthController.text;
    var physicianName = physicianNameController.text.trim();
    var presDate = prescriptionDate;
    var presDateStr = prescriptionDateString;
    medicationNameController.clear();
    medicationReasonController.clear();
    medicationDosageController.clear();
    medicationStrengthController.clear();
    physicianNameController.clear();
    prescriptionDate = null;
    prescriptionDateString = null;
    var medication = MedLogMedicationDetail(
        null, medName, medReason, medDosage, medStrength, null, null,
        prescriptionDate: presDate,
        prescriptionDateString: presDateStr,
        physicianName: physicianName.isEmpty ? null : physicianName);
    model.addMedicationSuggestion(medication);
    var addedMedications = model.fieldValue(CreateMedLogInputField.medications);
    if (addedMedications == null || addedMedications.isEmpty) {
      model.setValue<List<MedLogMedicationDetail>>(
          CreateMedLogInputField.medications, [medication]);
    } else {
      addedMedications.add(medication);
      model.setValue<List<MedLogMedicationDetail>>(
          CreateMedLogInputField.medications, addedMedications);
    }
  }

  Widget _listTile(
    int month,
    int year,
    String childName,
    String imageUrl, {
    VoidCallback onTap,
  }) {
    var date = DateTime(year, month);
    return MedLogCard(
      name: DateFormat.yMMMM().format(date),
      image: NetworkImage(imageUrl),
      description: childName,
      isCreate: true,
      onTap: onTap,
    );
  }

  @override
  void initState() {
    medicationNameController = TextEditingController();
    medicationReasonController = TextEditingController();
    medicationDosageController = TextEditingController();
    medicationStrengthController = TextEditingController();
    physicianNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    medicationNameController.dispose();
    medicationReasonController.dispose();
    medicationDosageController.dispose();
    medicationStrengthController.dispose();
    physicianNameController.dispose();
    super.dispose();
  }
}
