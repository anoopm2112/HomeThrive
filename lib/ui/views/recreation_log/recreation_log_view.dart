import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_view_model.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/rec_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/app_list_tile.dart';

class RecreationLogView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecreationLogViewState();
}

class _RecreationLogViewState extends State<RecreationLogView> {
  RecreationLogViewModel model;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<RecreationLogViewModel>.reactive(
        viewModelBuilder: () => RecreationLogViewModel(),
        onModelReady: (model) => model.onModelReady(),
        builder: (context, model, child) {
          this.model = model;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                localization.recreationLog,
                style: theme.appBarTheme.titleTextStyle.copyWith(
                  fontSize: getResponsiveMediumFontSize(context),
                ),
              ),
            ),
            body: SafeArea(
                child: model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.primaryColor,
                          ),
                        ),
                      )
                    : __List()),
            persistentFooterButtons: [
              if (!model.isBusy)
                TextButton(
                  onPressed: model.onNewRecLog,
                  child: Icon(AppIcons.add, color: theme.buttonColor),
                ),
            ],
          );
        });
  }

  Widget __List() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return CreationAwareWidget(
          onWidgetCreated: () => model.onTileCreated(index),
          child: index >= model.recreationLog.length
              ? AppListTile(
                  title: "",
                  subtitle: "",
                )
              : RecLogCard(
                  onTap: () => model.onTileTap(model.recreationLog[index].id),
                  name: model.recreationLog[index].child.nickName ??
                      model.recreationLog[index].child.firstName,
                  description: DateFormat.yMMMEd()
                          .format(model.recreationLog[index].createdAt) ??
                      "",
                ),
        );
      },
      itemCount: model.recreationLog.length,
    );
  }
}
