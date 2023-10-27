import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'med_logs_list_view_model.dart';

class MedLogView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MedLogViewState();
}

class _MedLogViewState extends State<MedLogView> {
  MedLogViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<MedLogViewModel>.reactive(
        viewModelBuilder: () => MedLogViewModel(),
        onModelReady: (model) => model.onModelReady(),
        fireOnModelReadyOnce: false,
        builder: (context, model, child) {
          this.model = model;
          return Scaffold(
            persistentFooterButtons: [
              if (!model.isBusy)
                TextButton(
                  onPressed: () => model.onTapAdd(),
                  child: Icon(
                    Icons.add,
                    color: theme.buttonColor,
                  ),
                ),
            ],
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => model.onClosePage(),
              ),
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
                : _medLogsList(),
          );
        });
  }

  Widget _medLogsList() {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        var log = model.logs[i];
        var tile = _listTile(
          log.month,
          log.year,
          log.child.nickName ?? "${log.child.firstName} ${log.child.lastName}",
          log.child.imageURL,
          (log.isSubmitted && log.signingStatus != null),
          log.signingStatus == SigningStatus.COMPLETED,
          (log.signingStatus != null &&
              log.signingStatus == SigningStatus.PENDING),
          log.canSign,
          i + 5 == model.logs.length ? () => model.onTileCreated(i) : null,
          () => model.onTapMedLog(log),
        );
        return tile;
      },
      itemCount: model.logs.length,
    );
  }

  Widget _listTile(
    int month,
    int year,
    String childName,
    String imageUrl,
    bool isSubmitted,
    bool isSigned,
    bool signPending,
    bool canSign,
    Function() onCreated,
    VoidCallback onTap,
  ) {
    var date = DateTime(year, month);
    return MedLogCard(
      name: DateFormat.yMMMM().format(date),
      image: NetworkImage(imageUrl),
      description: childName,
      isSigned: isSigned,
      signPending: signPending,
      isSubmitted: isSubmitted,
      canSign: canSign,
      onCardCreated: onCreated,
      onTap: onTap,
    );
  }
}
