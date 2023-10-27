import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/contact_us/contact_us_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class ContactUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<ContactUsViewModel>.nonReactive(
      viewModelBuilder: () => ContactUsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // TODO make into widget
          iconTheme: IconThemeData(
            color: Color(0xFF95A1AC),
          ),
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            localization.contactUs,
            style: GoogleFonts.montserrat(
              color: Color(0xFF95A1AC),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    PngAssetImages.handshake2,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                        height: 50), //TODO should be a percentage of height
                    Text(
                      localization.getInTouch,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        height: 1.1,
                        color: Color(0xFF1E2429),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.secondary400,
                        ),
                        onPressed: model.onEmailUs,
                        child: Text(
                          localization.emailUs, // TODO
                          style: textTheme.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
