import 'package:stacked/stacked.dart';

enum GuestBottomNavTab {
  home,
  resources,
  profile,
}

class GuestBottomNavViewModel extends BaseViewModel {
  GuestBottomNavTab _activeTab = GuestBottomNavTab.home;
  GuestBottomNavTab get activeTab => _activeTab;
  int get activeIndex => _activeTab.index;

  bool _reverse = false;
  bool get reverse => _reverse;

  void onTap(int newIndex) {
    assert(0 <= newIndex && newIndex <= GuestBottomNavTab.values.length - 1);

    if (newIndex <= activeIndex) {
      _reverse = true;
    } else {
      _reverse = false;
    }

    _activeTab = GuestBottomNavTab.values[newIndex];
    notifyListeners();
  }
}
