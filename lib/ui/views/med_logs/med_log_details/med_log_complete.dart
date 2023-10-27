import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view_model.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MedLogComplete extends ViewModelWidget<MedLogSummaryViewModel> {
  MedLogComplete({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogSummaryViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      localization.medlogSubmitSuccess +
                          " " +
                          DateFormat.yMMMM().format(model.logdate) +
                          "'s " +
                          localization.medLog,
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            fontWeight: FontWeight.w200,
                            height: 1.5,
                            fontSize: getResponsiveSmallFontSize(
                              context,
                            ),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
