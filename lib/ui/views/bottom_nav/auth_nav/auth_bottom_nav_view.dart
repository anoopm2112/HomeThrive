import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/auth_bottom_nav_service.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/views/activity/activity_view.dart';
import 'package:fostershare/ui/views/bottom_nav/auth_nav/auth_bottom_nav_view_model.dart';
import 'package:fostershare/ui/widgets/view_transition_switcher.dart';
import 'package:fostershare/ui/views/home/home_view.dart';
import 'package:fostershare/ui/views/profile/profile_view.dart';
import 'package:fostershare/ui/views/resources/resources_view.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:table_calendar/table_calendar.dart';

class AuthBottomNavView extends StatelessWidget {
  SpeedDial buildSpeedDial(context, model) {
    final theme = Theme.of(context);
    final AppLocalizations localization = AppLocalizations.of(context);
    return SpeedDial(
      icon: Icons.add,
      marginEnd: (MediaQuery.of(context).size.width - 22) / 2,
      marginBottom: 40,
      foregroundColor: Colors.white,
      activeIcon: Icons.close,
      backgroundColor: theme.primaryColor,
      visible: true,
      curve: Curves.bounceInOut,
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
      children: [
        SpeedDialChild(
          child: Icon(Icons.remember_me_outlined, color: Colors.white),
          backgroundColor: theme.primaryColor,
          onTap: model.onAddLog,
          labelWidget: SizedBox(
              //width: (MediaQuery.of(context).size.width - 70) / 2,
              child: Card(
                  // color: Colors.white70,
                  // elevation: 10.0,
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(localization.behaviorLog,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 9,
                              color: Colors.black))))),
          // label: localization.behaviorLog,
          // labelStyle: TextStyle(
          //     fontWeight: FontWeight.normal, fontSize: 10, color: Colors.black),
          // labelBackgroundColor: Colors.white70,
        ),
        SpeedDialChild(
          child: Icon(Icons.emoji_people, color: Colors.white),
          backgroundColor: theme.primaryColor,
          onTap: model.onRecreationLog,
          labelWidget: SizedBox(
              //width: (MediaQuery.of(context).size.width - 70) / 2,
              child: Card(
                  // color: Colors.white70,
                  // elevation: 10.0,
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(localization.recreationLog,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 9,
                              color: Colors.black))))),
          // label: localization.recreationLog,
          // labelStyle: TextStyle(
          //     fontWeight: FontWeight.normal, fontSize: 10, color: Colors.black),
          // labelBackgroundColor: Colors.white70,
        ),
        SpeedDialChild(
          child: Icon(Icons.medical_services, color: Colors.white),
          backgroundColor: theme.primaryColor,
          onTap: model.onMedLog,
          labelWidget: SizedBox(
              // width: (MediaQuery.of(context).size.width - 70) / 2,
              child: Card(
                  // color: Colors.white70,
                  // elevation: 10.0,
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(localization.medicationLog,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 9,
                            color: Colors.black,
                          ))))),
          // label: localization.medLog,
          // labelStyle: TextStyle(
          //     fontWeight: FontWeight.normal, fontSize: 10, color: Colors.black),
          // labelBackgroundColor: Colors.white70,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppLocalizations localization = AppLocalizations.of(context);
    return ViewModelBuilder<AuthBottomNavViewModel>.reactive(
      viewModelBuilder: () => AuthBottomNavViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: theme.primaryColor,
        //   onPressed: model.onAddLog,
        //   child: Icon(
        //     AppIcons.add,
        //     color: theme.dialogBackgroundColor,
        //   ),
        // ),
        floatingActionButton: buildSpeedDial(context, model),
        body: ViewTransitionSwitcher(
          reverse: model.reverse,
          child: _getViewForTab(model.activeTab),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            onTap: model.onTabTap,
            currentIndex: model.activeIndex,
            type: BottomNavigationBarType.fixed, // TODO check colors
            // TODO check font
            items: [
              BottomNavigationBarItem(
                label: localization.home,
                icon: Icon(AppIcons.homeOutlined),
                activeIcon: Icon(AppIcons.home),
              ),
              BottomNavigationBarItem(
                label: localization.resources,
                icon: Icon(AppIcons.booksOutlined),
                activeIcon: Icon(AppIcons.books),
              ),
              BottomNavigationBarItem(
                label: localization.addLog,
                tooltip: localization.addLog,
                icon: Icon(
                  AppIcons.history,
                  color: Colors.transparent,
                ),
              ),
              BottomNavigationBarItem(
                label: localization.activity,
                icon: Icon(AppIcons.historyOutlined),
                activeIcon: Icon(AppIcons.history),
              ),
              BottomNavigationBarItem(
                label: localization.profile,
                icon: Icon(AppIcons.userOutlined),
                activeIcon: Icon(AppIcons.user),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getViewForTab(AuthBottomNavTab tab) {
    switch (tab) {
      case AuthBottomNavTab.home:
        return HomeView();
      case AuthBottomNavTab.resources:
        return ResourcesView();
      case AuthBottomNavTab.activity:
        return ActivityView();
      case AuthBottomNavTab.profile:
        return ProfileView();
      default:
        return HomeView();
    }
  }
}
