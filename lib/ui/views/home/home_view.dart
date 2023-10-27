import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/home/auth/auth_home_view.dart';
import 'package:fostershare/ui/views/home/guest/guest_home_view.dart';
import 'package:fostershare/ui/views/home/home_view_model.dart';
import 'package:fostershare/ui/components/view_bar/view_bar.dart';
import 'package:stacked/stacked.dart';

class HomeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<HomeViewModel>.nonReactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: model.isSignedIn
                ? Theme.of(context).dialogBackgroundColor
                : null,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  IntrinsicHeight(
                    child: ViewBar(
                      title: localization.home,
                      trailing: model.isSignedIn
                          ? null
                          : Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: 4),
                              child: GestureDetector(
                                onTap: model.onSignIn,
                                child: Text(
                                  localization.signIn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: getResponsiveMediumFontSize(
                                          context,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                      notificationButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: model.isSignedIn ? AuthHomeView() : GuestHomeView(),
          ),
        ],
      ),
    );
  }
}
