import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding_item.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';

class Onboarding {
  Onboarding._();

  static final AppLocalizations _localization = AppLocalizations.current;

  static final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      assetImage: PngAssetImages.checkingCalendar,
      header: _localization.keepTrackOfImportantDates,
      description: _localization.keepTrackOfImportantDatesDescription,
    ),
    OnboardingItem(
      assetImage: PngAssetImages.womanOnChair,
      header: _localization.keepTrackOfYourRoutineLogs,
      description: _localization.keepTrackOfYourRoutineLogsDescription,
    ),
    // TODO replace other 1
    OnboardingItem(
      assetImage: PngAssetImages.handsOnPhone,
      header: _localization.resourcesAtYourFingertips,
      description: _localization.resourcesAtYourFingertipsDescription,
    ),
    OnboardingItem(
      assetImage: PngAssetImages.office,
      header: _localization.keepInTouchWithYourCaseManager,
      description: _localization.keepInTouchWithYourCaseManagerDescription,
    ),
  ];
}
