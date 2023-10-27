import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/add_log/add_log_view.dart';
import 'package:fostershare/ui/views/add_note/add_note_view.dart';
import 'package:fostershare/ui/views/notifications/notifications_view.dart';
import 'package:fostershare/ui/views/recreation_log/add_recreation_log/add_recreation_log_view.dart';
import 'package:fostershare/ui/views/med_logs/add_med_log/add_med_log_view.dart';
import 'package:fostershare/ui/views/med_log/create_med_log_view.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSheetService {
  final _navigationService = locator<NavigationService>();

  Future<ChildLog> addLog({
    DateTime date,
    Child child,
    bool skipParentSelection = false, // TODO look into
  }) {
    assert(skipParentSelection != null);

    return showModalBottomSheet<ChildLog>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        height: screenHeightPercentage(context, percentage: 95),
        child: AddLogView(
          date: date,
          child: child,
          skipParentSelection: skipParentSelection,
        ),
      ),
    );
  }

  Future<ChildLogNote> addNote({
    @required String childLogId,
  }) {
    assert(childLogId != null);

    return showModalBottomSheet<ChildLogNote>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: AddNoteView(
          childLogId: childLogId,
        ),
      ),
    );
  }

  Future<T> alerts<T>() {
    return showModalBottomSheet<T>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: NotificationsView(),
      ),
    );
  }

  Future<T> successfulSignIn<T>() {
    return showModalBottomSheet<T>(
        context: NavigationService.navigatorKey.currentContext,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (context) {
          var localization = AppLocalizations.of(context);
          return SafeArea(
            child: Container(
              height: screenHeightPercentage(context, percentage: 95),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => _navigationService.clearStackAndShow(
                        Routes.bottomNavView,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 28,
                        color: Color(0xFF95A1AC), // TODO
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    localization.signInSuccess,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      fontSize: 20,
                      color: AppColors.black900,
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    flex: 2,
                    child: Image.asset(PngAssetImages.family2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          localization.welcomeToFSFamily,
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
                  Flexible(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        onPressed: () => _navigationService.clearStackAndShow(
                          Routes.bottomNavView,
                        ),
                        child: Text(
                          localization.getStarted,
                          style: TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<ChildLog> editLog(Widget child) {
    return showModalBottomSheet<ChildLog>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        height: screenHeightPercentage(context, percentage: 95),
        child: child,
      ),
    );
  }

  Future<RecreationLog> addRecLog({
    DateTime date,
    Child child,
    bool skipParentSelection = false, // TODO look into
  }) {
    assert(skipParentSelection != null);

    return showModalBottomSheet<RecreationLog>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        height: screenHeightPercentage(context, percentage: 95),
        child: AddRecreationLogView(
          date: date,
          child: child,
          skipParentSelection: skipParentSelection,
        ),
      ),
    );
  }

  Future<MedLog> addMedLog({
    DateTime date,
    Child child,
    bool skipParentSelection = false,
    MedLog medLog,
    bool previewPage = false,
    bool detailPage = false, // TODO look into
  }) {
    assert(skipParentSelection != null);

    return showModalBottomSheet<MedLog>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        height: screenHeightPercentage(context, percentage: 95),
        child: AddMedLogView(
          date: date,
          child: child,
          skipParentSelection: skipParentSelection,
          medLog: medLog,
          previewPage: previewPage,
          detailPage: detailPage,
        ),
      ),
    );
  }
}
