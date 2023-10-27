import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/start_up/start_up_view_model.dart';
import 'package:fostershare/ui/widgets/foster_share_full_logo.dart';
import 'package:fostershare/ui/widgets/splash_background.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.nonReactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppColors.secondary400,
        body: SafeArea(
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
            child: Stack(
              children: [
                SplashBackground(),
                Center(
                  child: Hero(
                    tag: "center", // TODO
                    child: FosterShareFullLogo(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
