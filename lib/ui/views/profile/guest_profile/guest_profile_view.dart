import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/profile/guest_profile/guest_profile_view_model.dart';
import 'package:fostershare/ui/views/profile/invite_cpa/invite_cpa_card.dart';
import 'package:fostershare/ui/widgets/cards/detail_card.dart';
import 'package:stacked/stacked.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<GuestProfileViewModel>.nonReactive(
      viewModelBuilder: () => GuestProfileViewModel(),
      builder: (context, model, child) => SingleChildScrollView(
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 14,
                  top: 12,
                  right: 14,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.receievedAnInvite,
                      style: textTheme.headline3.copyWith(
                        fontSize: getResponsiveMediumFontSize(context),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      localization.clickBelowToLogin,
                      style: textTheme.bodyText2.copyWith(
                        fontSize: getResponsiveSmallFontSize(context),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: model.onLogin,
                        child: Text(
                          localization.signIn,
                          style: textTheme.button,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            InviteCpaCard(),
            SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: model.onTermsOfService,
                child: Text(localization.termsOfService),
              ),
            ),
            SizedBox(height: 12),
            DetailCard(
              title: localization.aboutFS,
              summary: localization.fsSummary,
            ),
            SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8ABAD3), // TODO
                ),
                onPressed: model.onContactUs,
                child: Text(
                  localization.contactUs,
                  style: textTheme.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
