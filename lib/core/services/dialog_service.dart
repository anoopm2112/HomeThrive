import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/app_update_availability/app_update_availability.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogService {
  final _navigationService = locator<NavigationService>();

  Future<T> appUpdateAvailability<T>({
    @required AppUpdateAvailability availability,
  }) {
    assert(availability != null && availability.updateAvailable);

    return showDialog<T>(
        context: NavigationService.navigatorKey.currentContext,
        useSafeArea: false,
        barrierDismissible: availability.updateRecommended,
        builder: (context) {
          var localization = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(
              availability.updateRequired
                  ? localization.updateRequired
                  : localization.updateRecommended,
            ),
            content: Text(localization.clickToUpdate),
            actions: <Widget>[
              if (availability.updateRecommended)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    localization.notNow,
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                  ),
                  onPressed: () => _navigationService.back(),
                ),
              TextButton(
                onPressed: () => launch(
                  availability.url.toString(),
                ),
                child: Text(
                  localization.update,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          );
        });
  }

  Future<T> onlyFosterParents<T>() {
    return showDialog<T>(
        context: NavigationService.navigatorKey.currentContext,
        builder: (context) {
          var localization = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(localization.signInAsFoster),
            actions: [
              TextButton(
                onPressed: () => _navigationService.back(),
                child: Text(
                  localization.ok,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          );
        });
  }

  Future<void> circularProgressIndicator() {
    return showDialog<void>(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
