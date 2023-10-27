import 'dart:io';

import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/app_update_availability/app_update_availability.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/input/get_app_update_availability_input/get_app_update_availability_input.dart';
import 'package:fostershare/core/services/app_service.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/dialog_service.dart';
import 'package:fostershare/core/services/graphql/guest/guest_graphql_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:graphql/client.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  final _appService = locator<AppService>();
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();
  final _guestGraphQLService = locator<GuestGraphQLService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _navigationService = locator<NavigationService>();

  Future<void> onModelReady() async {
    await _appService.init();
    await _authService.init();
    await _keyValueStorageService.init();

    bool isSignedIn;

    try {
      isSignedIn = await _authService
          .getAuthStatus(); // TODO should return false if it fails
    } catch (e) {
      isSignedIn = false;
    }

    if (isSignedIn) {
      _navigationService.clearStackAndShow(Routes.bottomNavView);
    } else {
      _navigationService.clearStackAndShow(Routes.welcomeView);
    }
    Future.delayed(Duration(seconds: 3), _checkAppAvailability);
  }

  _checkAppAvailability() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    var result = await _guestGraphQLService.appAvailability(
      GetAppUpdateAvailabilityInput(
        platform: Platform.isIOS ? AppPlatform.ios : AppPlatform.android,
        version: version,
      ),
    ); // TODO move to app service
    final AppUpdateAvailability availability = AppUpdateAvailability.fromJson(
      result.data["appUpdateAvailability"],
    );
    if (availability.updateRequired) {
      _dialogService.appUpdateAvailability(
        availability: availability,
      );
    } else if (availability.updateRecommended) {
      _dialogService.appUpdateAvailability(
        availability: availability,
      );
    }
  }
}
