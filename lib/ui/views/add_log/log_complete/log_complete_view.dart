import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/views/add_log/log_complete/log_complete_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class LogCompleteView extends StatelessWidget {
  final ChildLog childLog;

  const LogCompleteView({
    Key key,
    this.childLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LogCompleteViewModel>.nonReactive(
        viewModelBuilder: () => LogCompleteViewModel(
              childLog: childLog,
            ),
        builder: (context, model, child) {
          final localization = AppLocalizations.of(context);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            child: Column(
              // TODO widget
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: model.onBack,
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Color(0xFF95A1AC), // TODO
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  localization.logComplete,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    fontSize: 20,
                    color: AppColors.black900,
                  ),
                ),
                SizedBox(height: 22),
                Expanded(
                  flex: 2,
                  child: Image.asset(PngAssetImages.highFive),
                ),
                SizedBox(height: 32),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        localization.ultimateFosterParent,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          height: 1.083,
                          color: AppColors.black900,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        localization.hereToHelpNavigate,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          height: 1.143,
                          letterSpacing: .25,
                          fontSize: 14,
                          color: Color(0xFF57636C),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: OutlinedButton(
                      // TODO make into widget
                      onPressed: model.onBack,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(160, 50),
                        side: BorderSide(
                          width: 2,
                          color: Color(0xFFE6E6E6),
                        ),
                      ),

                      child: Text(
                        localization.ok,
                        style: TextStyle(
                          color: Color(0xFF57636C), // TODO
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
