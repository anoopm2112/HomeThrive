import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:stacked/stacked.dart';

class Medications extends ViewModelWidget<MedLogInputViewModel> {
  final List selectedMedications;
  final void Function(MedLogMedicationDetail medication) onMedicationSelected;
  final void Function(String medication) onNonAdministeredSelected;
  final String errorText;
  final bool selectNoneAdministered;

  Medications({
    Key key,
    this.selectedMedications,
    this.onNonAdministeredSelected,
    this.onMedicationSelected,
    this.errorText,
    this.selectNoneAdministered,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //primary: Colors.black,
                  minimumSize: const Size.fromHeight(45), // NEW
                ),
                onPressed: () => model.createMedication(),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    localization.addNewMedication,
                    //style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Icon(
                    Icons.add,
                    color: theme.buttonColor,
                  ),
                ])),
            SizedBox(height: 14),
            model.state == MedLogInputState.selectMedication
                ? SelectableButton(
                    value: "report_not_adminsterd",
                    selected: selectNoneAdministered,
                    onSelected: this.onNonAdministeredSelected,
                    height: 45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 6,
                        top: 8,
                        right: 6,
                        bottom: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            localization.reportNoneAdministered,
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(
                                context,
                                fontSize: 3.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(height: 1),
            SizedBox(height: 14),
            model.medicationList != null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ListView.separated(
                      itemCount: model.medicationList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final MedLogMedicationDetail medcine =
                            model.medicationList[index];

                        final select = this
                                .selectedMedications
                                .where((element) => element == medcine)
                                .isNotEmpty ??
                            false;
                        return SelectableButton<MedLogMedicationDetail>(
                          value: medcine,
                          selected: select,
                          onSelected: this.onMedicationSelected,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                              top: 8,
                              right: 6,
                              bottom: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${medcine.medicationName + ", " + medcine.dosage}",
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: getResponsiveFontSize(
                                      context,
                                      fontSize: 3.9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(height: 14),
          ],
        ),
      ],
    );
  }
}
