import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/core/models/data/resource_category/resource_category.dart';
import 'package:fostershare/core/models/data/resource_feed/resource_feed.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/resources_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _resourceService = locator<ResourcesService>();

  ResourcesViewModel() {
    _authService.addListener(this.onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(this.onAuthChanged);
    super.dispose();
  }

  bool get signedIn => _authService.signedIn;

  ResourceFeed _resourceFeed;
  ResourceFeed get resourceFeed => _resourceFeed;

  bool get showLocalResources =>
      this.signedIn && _resourceFeed.hasLocalResources;
  bool get showPopularCategory => _resourceFeed.hasPopularCategory;
  bool get showPopularTopics => _resourceFeed.numNonEmptyResourceCategories > 0;
  bool get hasResouces =>
      showLocalResources || showPopularCategory || showPopularTopics;

  int get popularTopicsCount => _resourceFeed.numNonEmptyResourceCategories;
  int get localResourcesCount => _resourceFeed.localResourcesCount;
  int get popularArticlesCount => _resourceFeed.popularCategory.resourcesCount;

  Future<void> onModelReady() async {
    setBusy(true);

    await _fetchResourceFeed();

    setBusy(false);
  }

  Future<void> onRefresh() async {
    _loggerService.info("ResourceViewModel - onRefresh()");

    await _fetchResourceFeed();
    notifyListeners();
  }

  void onAuthChanged() {
    notifyListeners();
    this.onRefresh();
  }

  Future<void> _fetchResourceFeed() async {
    this.clearErrors();

    try {
      this._resourceFeed = await _resourceService.resourceFeed();
    } catch (error, stackTrace) {
      _loggerService.error(
        "ResourceViewModel - Error geeting resource feed",
        error: error,
        stackTrace: stackTrace,
      );

      this.setError("Resource Feed Error");
    }
  }

  void onResourceCategoryTap(String id) {
    _navigationService.navigateTo(
      Routes.resourceCategoryView,
      arguments: ResourceCategoryViewArguments(id: id),
    );
  }

  ResourceCategory resourceCategory(int index) {
    assert(index >= 0);
    assert(index < this.popularTopicsCount);

    return this._resourceFeed.nonEmptyResourceCategories[index];
  }

  void onLocalResourcesTap() {
    assert(this._resourceFeed.hasLocalResources);

    _navigationService.navigateTo(
      Routes.localResourcesView,
      arguments: LocalResourcesViewArguments(
        resources: _resourceFeed.localResources,
      ),
    );
  }

  Resource popularArticle(int index) {
    assert(index >= 0);
    assert(index < this.popularArticlesCount);

    return this._resourceFeed.popularCategory.resources[index];
  }

  bool firstPopularArticle(int index) {
    assert(index >= 0);
    assert(index < this.popularArticlesCount);

    return index == 0;
  }

  bool lastPopularArticle(int index) {
    assert(index >= 0);
    assert(index < this.popularArticlesCount);

    return index == this.popularArticlesCount - 1;
  }

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
