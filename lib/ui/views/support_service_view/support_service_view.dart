import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/support_service_view/support_service_view_model.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:stacked/stacked.dart';

class SupportServiceView extends StatefulWidget {
  SupportServiceView(this.supportServiceId);
  final String supportServiceId;

  @override
  State<StatefulWidget> createState() => _SupportServiceViewState();
}

class _SupportServiceViewState extends State<SupportServiceView> {
  SupportServiceViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<SupportServiceViewModel>.reactive(
      viewModelBuilder: () => SupportServiceViewModel(widget.supportServiceId),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.supportService,
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
                  : _supportServiceDetails()),
        );
      },
    );
  }

  Widget _supportServiceDetails() {
    final localization = AppLocalizations.of(context);
    return ListView(
      children: [
        DetailTile(
          title: localization.name,
          value: model.supportService.name,
          description: model.supportService.description,
        ),
        if (model.supportService.email != null)
          DetailTile(
            title: localization.email,
            value: model.supportService.email,
            trailing: Icon(Icons.email, color: Colors.blue, size: 30),
            trailingAction: () => model.onEmailTap(model.supportService.email),
            onLongPress: () =>
                model.onLongPressEmail(model.supportService.email),
          ),
        if (model.supportService.phoneNumber != null)
          DetailTile(
            title: localization.phone,
            value: model.supportService.phoneNumber,
            trailing: _phoneActions(model.supportService.phoneNumber),
            onLongPress: () =>
                model.onLongPressPhone(model.supportService.phoneNumber),
          ),
        if (model.supportService.website != null)
          DetailTile(
            title: localization.website,
            value: model.supportService.website,
            trailing: Icon(Icons.launch, color: Colors.blue, size: 30),
            trailingAction: () =>
                model.onWebsiteTap(model.supportService.website),
            onLongPress: () =>
                model.onLongPressWebsite(model.supportService.website),
          ),
      ],
    );
  }

  Widget _phoneActions(String phoneNumber) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => model.onCallTap(phoneNumber),
          child: Icon(Icons.phone, color: Colors.blue, size: 30),
        ),
        SizedBox(width: 30),
        GestureDetector(
          onTap: () => model.onSmsTap(phoneNumber),
          child: Icon(Icons.sms, color: Colors.blue, size: 30),
        )
      ],
    );
  }
}
