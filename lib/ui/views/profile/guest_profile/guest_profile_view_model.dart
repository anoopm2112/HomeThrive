import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/env/env.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onLogin() {
    _navigationService.navigateTo(Routes.loginView);
  }

  void onTermsOfService() {}

  Future<void> onFAQ() async {
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

  void onContactUs() {
    _navigationService.navigateTo(Routes.contactUsView);
  }
}
