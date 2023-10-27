import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogSubmit extends ViewModelWidget<MedLogInputViewModel> {
  final bool medLogChecked;
  final void Function(bool check) onMedLogChecked;
  final String errorText;
  MedLogSubmit({
    Key key,
    this.medLogChecked,
    this.onMedLogChecked,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextColumn(
                headline: localization.initialAndSubmit,
                subheadline: "", //TODO
                error: this.errorText,
              ),
              if (model.noneAdministered && model.activeMedication == null)
                _noneAdminsteredDetails(context, model),
              if (model.noneAdministered && model.activeMedication != null)
                _medicationDetailsNoneAdminstered(context, model),
              if (!model.noneAdministered && model.activeMedication != null)
                _medicationDetailsField(context, model),
              SizedBox(height: 20),
              Text(localization.agreeTheMedication),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Checkbox(
                      value: model.chkVvalue,
                      onChanged: this.onMedLogChecked,
                    ),
                  ),
                  Text(
                    "${getInitials(string: model.parentName, limitTo: 2)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(width: 300),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setState(Null Function() param0) {}
  String getInitials({String string, int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo ?? split.length); i++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }

  Widget _medicationDetailsField(context, model) {
    final localization = AppLocalizations.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.nameOfMedication,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            model.activeMedication.medicationName,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.dosage,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.activeMedication.dosage}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.administeredTime,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${DateFormat.jm().format(model.fieldValue<DateTime>(
                  CreateMedicationInputField.dateTime,
                )) + ", " + DateFormat.yMMMEd().format(model.fieldValue<DateTime>(
                  CreateMedicationInputField.dateTime,
                ))}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.loggedTime,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${DateFormat.jm().format(DateTime.now()) + ", " + DateFormat.yMMMEd().format(DateTime.now())}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.administeredBy,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.parentName}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.administeredTo,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.child.firstName + " " + model.child.lastName}",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _medicationDetailsNoneAdminstered(context, model) {
    final localization = AppLocalizations.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.nameOfMedication,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            model.activeMedication.medicationName,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.dosage,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.activeMedication.dosage}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.administered,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            localization.no,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.reasonNotAdministered,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.getFailureReasonString(model.fieldValue(
              CreateMedicationInputField.failReason,
            ))}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
          Text(
            localization.notes,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(
            "${model.fieldValue(
              CreateMedicationInputField.failDescription,
            )}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _noneAdminsteredDetails(context, model) {
    final localization = AppLocalizations.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${localization.noMedineAdminitered + model.fieldValue<String>(
                  CreateMedicationInputField.dateString,
                )} ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }
}
