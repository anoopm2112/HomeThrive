import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log/child_sex_enum.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/generic_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'med_log_extended_details_view_model.dart';

class MedLogExtendedDetailsView extends StatefulWidget {
  final medLogId;

  MedLogExtendedDetailsView(this.medLogId);

  @override
  State<StatefulWidget> createState() => _MedLogExtendedDetailsViewState();
}

class _MedLogExtendedDetailsViewState extends State<MedLogExtendedDetailsView> {
  MedLogExtendedDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<MedLogExtendedDetailsViewModel>.reactive(
        viewModelBuilder: () => MedLogExtendedDetailsViewModel(widget.medLogId),
        onModelReady: (model) => model.onModelReady(),
        fireOnModelReadyOnce: false,
        builder: (context, model, child) {
          this.model = model;
          return Scaffold(
            appBar: AppBar(
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
                : _scrollableBody(),
          );
        });
  }

  Widget _scrollableBody() {
    return Container(
      child: CustomScrollView(
        slivers: [
          _medLogDetailsList(),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text("Medications"),
            ),
          ),
          _medicationList(),
        ],
      ),
    );
  }

  Widget _medicationTile(MedLogMedicationDetail medication) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return GenericCard(
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
          )
        ],
      ),
    );
  }

  Widget _medicationList() {
    var theme = Theme.of(context);
    return SliverList(
      delegate: SliverChildListDelegate([
        ...model.medLog.medications
            .map(
              (e) => _medicationTile(e),
            )
            .toList(),
      ]),
    );
  }

  Widget _medLogDetailsList() {
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
          margin: EdgeInsets.only(left: 5, right: 5),
          child: DetailTile(
            small: true,
            title: "Sex",
            value: model.medLog.childSex == ChildSex.Male
                ? "Male"
                : model.medLog.childSex == ChildSex.Female
                    ? "Female"
                    : "Other",
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: DetailTile(
            small: true,
            title: "Allergies",
            value: model.medLog.allergies ?? "-",
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: DetailTile(
            small: true,
            title: "Submitted By",
            value: model.medLog.submittedBy ?? "-",
          ),
        ),
        if (model.medLog.signingStatus == SigningStatus.COMPLETED)
          Align(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(top: 5, right: 10, left: 10),
              child: MaterialButton(
                color: theme.accentColor,
                textColor: theme.buttonColor,
                visualDensity: VisualDensity.compact,
                child: Text("View Document"),
                onPressed: () => model.onTapViewDocument(),
              ),
            ),
          ),
      ]),
    );
  }
}
