import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';

extension PickedFileExtensions on PickedFile {
  Future<String> toBase64() async {
    return base64.encode(await this.readAsBytes());
  }
}

const EdgeInsets defaultViewPaddingHorizontal = const EdgeInsets.symmetric(
  horizontal: 20,
);

final EdgeInsets defaultViewChildPaddingHorizontal =
    defaultViewPaddingHorizontal.add(
  EdgeInsets.symmetric(
    horizontal: 1.5,
  ),
);

final SizedBox defaultViewSpacingTop = SizedBox(height: 16);

String svgImageFromMoodRating(MoodRating moodRating) {
  switch (moodRating) {
    case MoodRating.great:
      return SvgAssetImages.awesome;
    case MoodRating.good:
      return SvgAssetImages.good;
    case MoodRating.average:
      return SvgAssetImages.neutral;
    case MoodRating.soso:
      return SvgAssetImages.notGreat;
    case MoodRating.hardDay:
    default:
      return SvgAssetImages.sad;
  }
}

String svgImageFromChildBehavior(ChildBehavior behavior) {
  switch (behavior) {
    case ChildBehavior.agression:
      return SvgAssetImages.violence;
    case ChildBehavior.anxiety:
      return SvgAssetImages.anxiety;
    case ChildBehavior.bedWetting:
      return SvgAssetImages.bedWetting;
    case ChildBehavior.depression:
      return SvgAssetImages.depression;
    case ChildBehavior.schoolIssues:
      return SvgAssetImages.school;
    case ChildBehavior.food:
      return SvgAssetImages.food;
    case ChildBehavior.other:
    default:
      return SvgAssetImages.other;
  }
}

String pngImageFromDailyActivity(DailyIndoorOutdoorActivity dailyActivity) {
  switch (dailyActivity) {
    case DailyIndoorOutdoorActivity.teamwork:
      return PngAssetImages.teamwork;
    case DailyIndoorOutdoorActivity.fitness:
      return PngAssetImages.fitness;
    case DailyIndoorOutdoorActivity.coordination:
      return PngAssetImages.coordination;
    case DailyIndoorOutdoorActivity.communicationSkill:
      return PngAssetImages.communicationSkill;
    case DailyIndoorOutdoorActivity.socialSkill:
      return PngAssetImages.socialSkill;
    case DailyIndoorOutdoorActivity.relational:
      return PngAssetImages.relational;
    case DailyIndoorOutdoorActivity.sharing:
      return PngAssetImages.sharing;
    case DailyIndoorOutdoorActivity.problemSolving:
      return PngAssetImages.problemSolving;
    case DailyIndoorOutdoorActivity.handEyeCoordination:
      return PngAssetImages.handEyeCoordination;
    case DailyIndoorOutdoorActivity.impluseControl:
      return PngAssetImages.impluseControl;
    case DailyIndoorOutdoorActivity.createExpression:
      return PngAssetImages.createExpression;
    case DailyIndoorOutdoorActivity.selfesteem:
    default:
      return PngAssetImages.selfesteem;
  }
}

String pngImageFromFreeTimeActivity(
    IndividualFreeTImeActivity freeTimeActivity) {
  switch (freeTimeActivity) {
    case IndividualFreeTImeActivity.stressManagement:
      return PngAssetImages.stressManagement;
    case IndividualFreeTImeActivity.healthAutonomy:
      return PngAssetImages.healthAutonomy;
    case IndividualFreeTImeActivity.personalGrowth:
      return PngAssetImages.personalGrowth;
    case IndividualFreeTImeActivity.selfEvaluation:
      return PngAssetImages.selfEvaluation;
    case IndividualFreeTImeActivity.createExpression:
    default:
      return PngAssetImages.createExpression;
  }
}

String pngImageFromCommunityActivity(CommunityActivity communityActivity) {
  switch (communityActivity) {
    case CommunityActivity.socialSkillPractice:
      return PngAssetImages.socialSkillPractice;
    case CommunityActivity.connectWithCulture:
      return PngAssetImages.connectWithCulture;
    case CommunityActivity.independentLiving:
      return PngAssetImages.independentLiving;
    case CommunityActivity.socialContribution:
      return PngAssetImages.socialContribution;
    case CommunityActivity.communicationSkills:
    default:
      return PngAssetImages.communicationSkills;
  }
}

String pngImageFromFamilyActivity(FamilyActivity familyActivity) {
  switch (familyActivity) {
    case FamilyActivity.familyCohesion:
      return PngAssetImages.familyCohesion;
    case FamilyActivity.relationalSkills:
      return PngAssetImages.relationalSkills;
    case FamilyActivity.senseOfBelonging:
      return PngAssetImages.senseOfBelonging;
    case FamilyActivity.roleModelLifeSkills:
      return PngAssetImages.roleModelLifeSkills;
    case FamilyActivity.socialIntegration:
    default:
      return PngAssetImages.socialIntegration;
  }
}

String labelFromDailyActivity(
    DailyIndoorOutdoorActivity dailyActivity, AppLocalizations localizations) {
  switch (dailyActivity) {
    case DailyIndoorOutdoorActivity.teamwork:
      return localizations.teamWork;
    case DailyIndoorOutdoorActivity.fitness:
      return localizations.fitness;
    case DailyIndoorOutdoorActivity.coordination:
      return localizations.coordination;
    case DailyIndoorOutdoorActivity.communicationSkill:
      return localizations.communicationSkill;
    case DailyIndoorOutdoorActivity.socialSkill:
      return localizations.socialSkill;
    case DailyIndoorOutdoorActivity.selfesteem:
      return localizations.selfEsteem;
    case DailyIndoorOutdoorActivity.relational:
      return localizations.relational;
    case DailyIndoorOutdoorActivity.sharing:
      return localizations.sharing;
    case DailyIndoorOutdoorActivity.problemSolving:
      return localizations.problemSolving;
    case DailyIndoorOutdoorActivity.handEyeCoordination:
      return localizations.handEyeCordination;
    case DailyIndoorOutdoorActivity.impluseControl:
      return localizations.impluseControl;
    case DailyIndoorOutdoorActivity.createExpression:
      return localizations.creativeExpression;
    default:
      return "";
  }
}

String labelFromFreeTimeActivity(IndividualFreeTImeActivity freeTimeActivity,
    AppLocalizations localizations) {
  switch (freeTimeActivity) {
    case IndividualFreeTImeActivity.stressManagement:
      return localizations.stressManagement;
    case IndividualFreeTImeActivity.healthAutonomy:
      return localizations.healthyAnotonomy;
    case IndividualFreeTImeActivity.personalGrowth:
      return localizations.personalGrowth;
    case IndividualFreeTImeActivity.selfEvaluation:
      return localizations.selfEvaluaton;
    case IndividualFreeTImeActivity.createExpression:
      return localizations.creativeExpression;
    default:
      return "";
  }
}

String labelFromCommunityActivity(
    CommunityActivity communityActivity, AppLocalizations localizations) {
  switch (communityActivity) {
    case CommunityActivity.socialSkillPractice:
      return localizations.socialSkillsPractice;
    case CommunityActivity.connectWithCulture:
      return localizations.connectWithCulture;
    case CommunityActivity.independentLiving:
      return localizations.independentLiving;
    case CommunityActivity.socialContribution:
      return localizations.socialContribution;
    case CommunityActivity.communicationSkills:
      return localizations.communicationSkills;
    default:
      return "";
  }
}

String labelFromFamilyActivity(
    FamilyActivity familyActivity, AppLocalizations localizations) {
  switch (familyActivity) {
    case FamilyActivity.familyCohesion:
      return localizations.familyCohesion;
    case FamilyActivity.relationalSkills:
      return localizations.relational;
    case FamilyActivity.senseOfBelonging:
      return localizations.senseOfBelonging;
    case FamilyActivity.roleModelLifeSkills:
      return localizations.roleModelLifeSkills;
    case FamilyActivity.socialIntegration:
      return localizations.socialIntegration;
    default:
      return "";
  }
}
