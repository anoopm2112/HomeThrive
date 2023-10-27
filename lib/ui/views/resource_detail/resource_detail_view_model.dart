import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class ResourceDetailViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onBack() {
    _navigationService.back();
  }
}
