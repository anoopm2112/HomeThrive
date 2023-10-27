import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/profile/auth_profile/auth_profile_view.dart';
import 'package:fostershare/ui/views/profile/guest_profile/guest_profile_view.dart';
import 'package:fostershare/ui/views/profile/profile_view_model.dart';
import 'package:fostershare/ui/components/view_bar/view_bar.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Column(
        // TODO function
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
                  defaultViewSpacingTop,
                  ViewBar(
                    title: localization.profile,
                    notificationButton: model.showNotificationButton,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: model.isSignedIn ? AuthProfileView() : GuestProfileView(),
          ),
        ],
      ),
    );
  }
}
