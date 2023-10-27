import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/welcome/welcome_view_model.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/foster_share_full_logo.dart';
import 'package:stacked/stacked.dart';

class WelcomeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<WelcomeViewModel>.reactive(
      viewModelBuilder: () => WelcomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.secondary400,
          body: Stack(
            children: [
              SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      focalRadius: 0.8,
                      radius: 1.2,
                      center: Alignment.center,
                      focal: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   child:
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: "center",
                                child: FosterShareFullLogo(),
                              ),
                              SizedBox(height: 22),
                              // Text(
                              //   localization.connectingParentsAndAgencies,
                              //   textAlign: TextAlign.center,
                              //   style: textTheme.headline3.copyWith(
                              //     fontWeight: FontWeight.w100,
                              //     fontSize: 14,
                              //     height: 1.143,
                              //     letterSpacing: .25,
                              //     color: textTheme.headline2.color,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        //  ),
                        SizedBox(height: 50),
                        TextButton(
                          onPressed: model.onSignIn,
                          style: TextButton.styleFrom(
                            backgroundColor: theme
                                .textTheme.button.color, // TODO colors theme
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            localization.signIn,
                            style: textTheme.button
                                .copyWith(color: AppColors.orange500),
                          ),
                        ),
                        SizedBox(height: 16),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                              double.infinity,
                              50,
                            ),
                          ),
                          onPressed: model.onContinueWithoutAccount,
                          child: Text(
                            localization.continueWithoutAccount,
                            style: textTheme.button,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
