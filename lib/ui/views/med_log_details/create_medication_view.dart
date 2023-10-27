import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_log_details/create_medication_view_model.dart';
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

class CreateMedicationView extends StatefulWidget {
  final String medLogId;

  CreateMedicationView(this.medLogId);

  @override
  State<StatefulWidget> createState() => _CreateMedicationViewState();
}

class _CreateMedicationViewState extends State<CreateMedicationView> {
  TextEditingController medicationNameController;
  TextEditingController medicationReasonController;
  TextEditingController medicationDosageController;
  TextEditingController medicationStrengthController;
  TextEditingController physicianNameController;
  CreateMedicationViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<CreateMedicationViewModel>.reactive(
      viewModelBuilder: () => CreateMedicationViewModel(widget.medLogId),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Create Medication", //TODO: Localization
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
              : _createMedication(),
        );
      },
    );
  }

  Widget _createMedication() {
    var theme = Theme.of(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text("Medication Details"),
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Name",
                      controller: medicationNameController,
                      textInputAction: TextInputAction.next,
                      errorText: model.fieldValidationMessage(
                        CreateMedicationInputField.name,
                      ),
                      onChanged: (val) =>
                          model.setValue(CreateMedicationInputField.name, val),
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Strength",
                      controller: medicationStrengthController,
                      textInputAction: TextInputAction.next,
                      errorText: model.fieldValidationMessage(
                        CreateMedicationInputField.strength,
                      ),
                      onChanged: (val) => model.setValue(
                          CreateMedicationInputField.strength, val),
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Dosage",
                      controller: medicationDosageController,
                      textInputAction: TextInputAction.next,
                      errorText: model.fieldValidationMessage(
                        CreateMedicationInputField.dosage,
                      ),
                      onChanged: (val) => model.setValue(
                          CreateMedicationInputField.dosage, val),
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      labelText: "Reason",
                      controller: medicationReasonController,
                      errorText: model.fieldValidationMessage(
                        CreateMedicationInputField.reason,
                      ),
                      onChanged: (val) => model.setValue(
                          CreateMedicationInputField.reason, val),
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                        labelText: "Physician Name",
                        controller: physicianNameController,
                        errorText: model.fieldValidationMessage(
                          CreateMedicationInputField.physicianName,
                        ),
                        onChanged: (val) {
                          model.setValue(
                              CreateMedicationInputField.physicianName,
                              val?.trim());
                        }),
                    SizedBox(height: 10),
                    _dateField(),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: MaterialButton(
                          onPressed: () => model.createMedication(),
                          color: theme.accentColor,
                          child: Text(
                            "Create",
                            style: TextStyle(color: theme.buttonColor),
                          ),
                        ),
                      ),
                    ),
                  ],
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
    var dateString =
        model.fieldValue(CreateMedicationInputField.prescriptionDateString);
    return Container(
      child: DetailTile(
        title: "Prescription Date",
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
            model.updatePrescriptionDate(newDate);
          }
        },
      ),
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
