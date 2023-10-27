import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalResourcesViewModel extends BaseViewModel {
  Future<void> onResourceTap(Uri resourceUri) async {
    final String resourceUrl = resourceUri.toString();
    if (await canLaunch(resourceUrl)) {
      launch(
        // TODO service?
        resourceUrl,
        forceWebView: true,
        enableJavaScript: true,
        enableDomStorage: true,
      );
    } else {
      // TODO pop up dialog/notification
      // reload in background?
    }
  }
}
