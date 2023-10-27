import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/views/bottom_nav/guest_nav/guest_bottom_nav_view_model.dart';
import 'package:fostershare/ui/views/home/home_view.dart';
import 'package:fostershare/ui/views/profile/profile_view.dart';
import 'package:fostershare/ui/views/resources/resources_view.dart';
import 'package:stacked/stacked.dart';

class GuestBottomNavView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<GuestBottomNavViewModel>.reactive(
      viewModelBuilder: () => GuestBottomNavViewModel(),
      builder: (context, model, child) => Scaffold(
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 600),
          reverse: model.reverse,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
          child: _getViewForTab(model.activeTab),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            onTap: model.onTap,
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

  Widget _getViewForTab(GuestBottomNavTab tab) {
    switch (tab) {
      case GuestBottomNavTab.home:
        return HomeView();
      case GuestBottomNavTab.resources:
        return ResourcesView();
      case GuestBottomNavTab.profile:
        return ProfileView();
      default:
        return HomeView();
    }
  }
}
