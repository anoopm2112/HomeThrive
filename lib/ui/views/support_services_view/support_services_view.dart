import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/support_services_view/support_services_view_model.dart';
import 'package:fostershare/ui/widgets/app_list_tile.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:stacked/stacked.dart';

class SupportServicesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupportServicesViewState();
}

class _SupportServicesViewState extends State<SupportServicesView> {
  SupportServicesViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<SupportServicesViewModel>.reactive(
      viewModelBuilder: () => SupportServicesViewModel(),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.supportServices,
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
                  : _supportServiceList()),
        );
      },
    );
  }

  Widget _supportServiceList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return CreationAwareWidget(
          onWidgetCreated: () => model.onTileCreated(index),
          child: index >= model.supportServices.length
              ? AppListTile(
                  title: "",
                  subtitle: "",
                )
              : AppListTile(
                  onTap: () => model.onTileTap(model.supportServices[index].id),
                  title: model.supportServices[index].name,
                  subtitle: model.supportServices[index].description ?? "",
                ),
        );
      },
      itemCount: model.supportServices.length,
    );
  }
}
