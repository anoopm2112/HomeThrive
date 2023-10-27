import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/string_utils.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';

class MoodSelectionRow extends StatelessWidget {
  final MoodRating selectedMood;
  final void Function(MoodRating moodRating) onMoodRatingSelected;

  const MoodSelectionRow({
    Key key,
    this.selectedMood,
    this.onMoodRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: MoodRating.values
          .map<Widget>(
            (moodRating) => SelectableButton(
              value: moodRating,
              selected: this.selectedMood == moodRating,
              onSelected: this.onMoodRatingSelected,
              height: screenHeightPercentage(context, percentage: 14),
              width: screenWidthPercentage(context, percentage: 17.6),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 6,
                  top: 8,
                  right: 6,
                  bottom: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svgImageFromMoodRating(moodRating),
                      width: screenWidthPercentage(context, percentage: 10.67),
                      height: screenWidthPercentage(context, percentage: 10.67),
                    ),
                    SizedBox(height: 6),
                    AutoSizeText(
                      _moodLabelFromMoodRating(moodRating, localization),
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _moodLabelFromMoodRating(
      MoodRating moodRating, AppLocalizations localizations) {
    switch (moodRating) {
      case MoodRating.great:
        return localizations.great;
      case MoodRating.good:
        return localizations.good;
      case MoodRating.average:
        return localizations.average;
      case MoodRating.soso:
        return localizations.soso;
      case MoodRating.hardDay:
      default:
        return localizations.hardDay;
    }
  }
}
