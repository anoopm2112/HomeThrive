import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SigningView extends ViewModelWidget<MedLogSummaryViewModel> {
  SigningView({
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
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
          child: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                )
              : SafeArea(
                  child: WebView(
                    initialUrl: model.signingUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (url) {
                      if (url.startsWith(model.finalUrl)) {
                        //Navigator.pop(context);
                        model.backFromWeb();
                      }
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
