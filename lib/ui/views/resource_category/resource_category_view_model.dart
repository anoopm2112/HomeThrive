import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/resource_category/resource_category.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/resources_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCategoryViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _resourceService = locator<ResourcesService>();

  ResourceCategory _resourceCategory;
  ResourceCategory get resourceCategory => _resourceCategory;

  Future<void> onModelReady(String id) async {
    setBusy(true);

    _resourceCategory = await _resourceService.resourceCategory(id);

    setBusy(false);
  }

  void onBack() {
    _navigationService.back();
  }

  Future<void> onResourceTap(Uri resourceUri) async {
    final String resourceUrl = resourceUri.toString();
    if (await canLaunch(resourceUrl)) {
      launch(
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
