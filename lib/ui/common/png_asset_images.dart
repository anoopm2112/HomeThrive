class PngAssetImages {
  const PngAssetImages._();

  static const String _assetImagesPath = "assets/images";
  static const String _png = "png";

  static String get agent => _pngAssetPath("agent");
  static String get calendar => _pngAssetPath("calendar");
  static String get family => _pngAssetPath("family");
  static String get fileCabinet => _pngAssetPath("file_cabinet");
  static String get handshake => _pngAssetPath("handshake");
  static String get resourceCarousel => _pngAssetPath("resource_carousel");
  static String get checkingCalendar => _pngAssetPath("checking_calendar");
  static String get family2 => _pngAssetPath("family2");
  static String get handsOnPhone => _pngAssetPath("hands_on_phone");
  static String get handshake2 => _pngAssetPath("handshake2");
  static String get highFive => _pngAssetPath("high_five");
  static String get office => _pngAssetPath("office");
  static String get womanOnChair => _pngAssetPath("woman_on_chair");
  static String get medLog => _pngAssetPath("medlog");
  static String get dailyLog => _pngAssetPath("dailylog");
  static String get recLog => _pngAssetPath("reclog");
  static String get teamwork => _pngAssetPath("coordination");
  static String get fitness => _pngAssetPath("fitness");
  static String get coordination => _pngAssetPath("trained");
  static String get communicationSkill => _pngAssetPath("communication");
  static String get socialSkill => _pngAssetPath("group_co");
  static String get selfesteem => _pngAssetPath("self");
  static String get relational => _pngAssetPath("relational");
  static String get sharing => _pngAssetPath("sharing");
  static String get problemSolving => _pngAssetPath("problem_solving");
  static String get handEyeCoordination => _pngAssetPath("musician");
  static String get impluseControl => _pngAssetPath("clock");
  static String get createExpression => _pngAssetPath("hobby");
  static String get stressManagement => _pngAssetPath("stress");
  static String get healthAutonomy => _pngAssetPath("independent");
  static String get personalGrowth => _pngAssetPath("growth");
  static String get selfEvaluation => _pngAssetPath("yourself");
  static String get socialSkillPractice => _pngAssetPath("social_skill");
  static String get connectWithCulture => _pngAssetPath("gateway");
  static String get independentLiving => _pngAssetPath("cooked");
  static String get socialContribution => _pngAssetPath("volunteer");
  static String get communicationSkills => _pngAssetPath("communication");
  static String get familyCohesion => _pngAssetPath("family_co");
  static String get relationalSkills => _pngAssetPath("relational");
  static String get senseOfBelonging => _pngAssetPath("team");
  static String get roleModelLifeSkills => _pngAssetPath("abilities");
  static String get socialIntegration => _pngAssetPath("group");
  static String get events => _pngAssetPath("events");
  static String get pastDue => _pngAssetPath("late_log");
  static String get montlyMedLog => _pngAssetPath("monthly_med_log");
  static final values = [
    agent,
    calendar,
    family,
    fileCabinet,
    handshake,
    resourceCarousel,
    checkingCalendar,
    family2,
    handsOnPhone,
    handshake2,
    highFive,
    office,
    womanOnChair,
    medLog,
    dailyLog,
    recLog,
    teamwork,
    fitness,
    coordination,
    communicationSkill,
    socialSkill,
    selfesteem,
    relational,
    sharing,
    problemSolving,
    handEyeCoordination,
    impluseControl,
    createExpression,
    stressManagement,
    healthAutonomy,
    personalGrowth,
    selfEvaluation,
    socialSkillPractice,
    connectWithCulture,
    independentLiving,
    socialContribution,
    communicationSkills,
    familyCohesion,
    relationalSkills,
    senseOfBelonging,
    roleModelLifeSkills,
    socialIntegration,
    events,
    pastDue,
    montlyMedLog
  ];

  static String _pngAssetPath(String assetFileName) {
    return "$_assetImagesPath/$assetFileName.$_png";
  }
}
