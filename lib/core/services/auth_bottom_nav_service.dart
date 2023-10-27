import 'package:stacked/stacked.dart';

enum AuthBottomNavTab {
  home,
  resources,
  empty,
  activity,
  profile,
}

class AuthBottomNavService with ReactiveServiceMixin {
  AuthBottomNavTab _activeTab = AuthBottomNavTab.home;
  AuthBottomNavTab get activeTab => _activeTab;
  int get activeIndex => _activeTab.index;

  bool _reverse = false;
  bool get reverse => _reverse;

  void changeTap(int newIndex) {
    assert(0 <= newIndex && newIndex <= AuthBottomNavTab.values.length - 1);

    if (newIndex != activeIndex) {
      if (newIndex < activeIndex) {
        _reverse = true;
      } else {
        _reverse = false;
      }

      final AuthBottomNavTab potentialTab = AuthBottomNavTab.values[newIndex];
      if (potentialTab != AuthBottomNavTab.empty) {
        _activeTab = potentialTab;
      }
      notifyListeners();
    }
  }
}
