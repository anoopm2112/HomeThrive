import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/add_log/log_questions/upload_photos_button/upload_photos_button.dart';
import 'package:fostershare/ui/widgets/log_column.dart';
import 'package:image_picker/image_picker.dart';

class ChildLogReview extends StatelessWidget {
  final void Function(PickedFile file) onImageSelected;
  final String selectedImageFileName;
  final MoodRating dayRating;
  final String dayRatingComments;
  final MoodRating parentMoodRating;
  final String parentMoodComments;
  final List<ChildBehavior> behavioral;
  final String behavioralComments;
  final bool familyVisit;
  final String familyVisitComments;
  final MoodRating childMoodRating;
  final String childMoodComments;
  final bool medicationChange;
  final String medicationChangeComments;

  const ChildLogReview({
    // TODO pass in child log
    Key key,
    this.onImageSelected,
    this.selectedImageFileName,
    @required this.dayRating,
    this.dayRatingComments,
    @required this.parentMoodRating,
    this.parentMoodComments,
    this.behavioral,
    this.behavioralComments,
    @required this.familyVisit,
    this.familyVisitComments,
    @required this.childMoodRating,
    this.childMoodComments,
    this.medicationChange,
    this.medicationChangeComments,
  })  : assert(dayRating != null),
        assert(parentMoodRating != null),
        assert(familyVisit != null),
        assert(childMoodRating != null),
        //assert(medicationChange != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: padding,
          child: Text(
            localization.reviewLog,
            style: textTheme.headline1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: getResponsiveLargeFontSize(context),
            ),
          ),
        ),
        LogColumn(
          dayRating: this.dayRating,
          dayRatingComments: this.dayRatingComments,
          parentMoodRating: this.parentMoodRating,
          parentMoodComments: this.parentMoodComments,
          behavioral: this.behavioral,
          behavioralComments: this.behavioralComments,
          familyVisit: this.familyVisit,
          familyVisitComments: this.familyVisitComments,
          childMoodRating: this.childMoodRating,
          childMoodComments: this.childMoodComments,
          medicationChange: this.medicationChange,
          medicationChangeComments: this.medicationChangeComments,
          endBorder: true,
        ),
        SizedBox(height: 16),
        Padding(
          padding: padding,
          child: Text(
            localization.uploadLogPhoto,
            style: textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: padding,
          child: UploadPhotosButton(
            onImageSelected: this.onImageSelected,
          ),
        ),
      ],
    );
  }
}
