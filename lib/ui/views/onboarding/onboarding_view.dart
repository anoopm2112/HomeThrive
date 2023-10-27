import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/components/onboarding_page_view.dart';
import 'package:fostershare/ui/views/onboarding/onboarding_view_model.dart';
import 'package:stacked/stacked.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.nonReactive(
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.white, // TODO
        body: OnboardingPageView(
          onboardingItems: model.onboardingItems,
          onComplete: model.onComplete,
        ),
      ),
    );
  }
}
