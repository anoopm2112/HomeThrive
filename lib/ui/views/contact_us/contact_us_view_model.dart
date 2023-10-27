import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/env/env.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsViewModel extends BaseViewModel {
  final _loggerService = locator<LoggerService>();

  Future<void> onGetHelp() async {
    final String faqUrl = Env.faqUrl.toString();
    if (await canLaunch(faqUrl)) {
      launch(
        faqUrl,
        forceWebView: true,
        enableJavaScript: true,
        enableDomStorage: true,
      );
    } else {
      // TODO log and display general error dialog
      print('Could not launch $faqUrl');
    }
  }

  Future<void> onEmailUs() async {
    final String emailUrl = Env.miracleFoundationEmail.toString();
    if (await canLaunch(emailUrl)) {
      launch(
        emailUrl,
      );
    } else {
      // TODO log and display email in dialog
      print('Could not launch $emailUrl');
    }
  }
}
