import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fostershare/ui/views/med_log_details/signing_view_model.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class SigningView extends StatelessWidget {
  final String signingUrl;
  final String finalUrl;
  final String medLogId;

  SigningView(this.signingUrl, this.finalUrl, this.medLogId);
  SigningViewModel model;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<SigningViewModel>.reactive(
        viewModelBuilder: () => SigningViewModel(medLogId),
        //onModelReady: (model) => model.onModelReady(),
        fireOnModelReadyOnce: false,
        builder: (context, model, child) {
          this.model = model;
          return new WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => model.onTapBack()),
                elevation: 0,
              ),
              body: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    )
                  : SafeArea(
                      child: WebView(
                        initialUrl: signingUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageStarted: (url) {
                          if (url.startsWith(finalUrl)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
            ),
          );
        });
  }
}
