import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/components/onboarding_page_view.dart';
import 'package:fostershare/ui/views/home/guest/guest_home_view_model.dart';
import 'package:stacked/stacked.dart';

class GuestHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<GuestHomeViewModel>.nonReactive(
      viewModelBuilder: () => GuestHomeViewModel(),
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: defaultViewPaddingHorizontal.copyWith(
              left: defaultViewPaddingHorizontal.left + 1.5,
              right: defaultViewPaddingHorizontal.right + 1.5, // TODO
            ),
            child: Text(
              localization.howToUseFosterShare,
              style: textTheme.bodyText1.copyWith(
                fontSize: getResponsiveSmallFontSize(context),
              ),
            ),
          ),
          Expanded(
            child: OnboardingPageView(
              // TODO keep page state
              onboardingItems: model.onboardingItems,
            ),
          ),
        ],
      ),
    );
  }
}
