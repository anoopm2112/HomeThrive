library onboarding;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/onboarding/onboarding_item.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fostershare/ui/common/app_colors.dart';

part 'onboarding/onboarding_column.dart';
part 'onboarding/onboarding_content.dart';

// TODO work on
class OnboardingPageView extends StatefulWidget {
  final void Function() onComplete;
  final List<OnboardingItem> onboardingItems;

  OnboardingPageView({
    Key key,
    this.onComplete,
    @required this.onboardingItems,
  })  : assert(onboardingItems != null && onboardingItems.isNotEmpty),
        super(key: key);

  @override
  _OnboardingPageViewState createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    final EdgeInsets textPadding = EdgeInsets.symmetric(horizontal: 20);
    final bool hasOnComplete = widget.onComplete != null;
    final bool isNotLastPage =
        _currentPage != widget.onboardingItems.length - 1;
    final bool showSkip = hasOnComplete;
    final bool showNext = isNotLastPage || hasOnComplete;

    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.onboardingItems.length,
          onPageChanged: (page) => setState(() {
            _currentPage = page;
          }),
          itemBuilder: (context, index) {
            final OnboardingItem onboardingItem = widget.onboardingItems[index];
            return _OnboardingColumn(
              start: Center(
                child: Image.asset(
                  onboardingItem.assetImage,
                ),
              ),
              child: Padding(
                padding: textPadding,
                child: Column(
                  children: [
                    AutoSizeText(
                      onboardingItem.header,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: textTheme.headline1.copyWith(
                        fontSize: getResponsiveLargeFontSize(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: AutoSizeText(
                        onboardingItem.description,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: getAreaResponsiveFontSize(
                            context,
                            fontSize: .0055,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Column(
          children: [
            Expanded(
              flex: 345,
              child: SizedBox(),
            ),
            Expanded(
              flex: 6,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.onboardingItems.length,
                onDotClicked: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                  );
                },
                effect: ExpandingDotsEffect(
                  dotWidth: 6,
                  dotHeight: 6,
                  expansionFactor: 4,
                  radius: 5,
                  activeDotColor: AppColors.orange500, // TODO get from theme
                  dotColor: Color(0x99223149), // TODO
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 240,
              child: Column(
                // TODO
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: showNext ? 1 : 0,
                          duration: Duration(milliseconds: 500),
                          child: ElevatedButton(
                            onPressed: () {
                              if (isNotLastPage) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 700),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                if (widget.onComplete != null) {
                                  widget.onComplete();
                                }
                              }
                            },
                            child: Text(
                              localization.next,
                              style: textTheme.button,
                            ),
                          ),
                        ),
                        if (showSkip) ...[
                          SizedBox(height: 6),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: widget.onComplete,
                            child: Text(
                              localization.skip,
                              style: textTheme.bodyText2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
