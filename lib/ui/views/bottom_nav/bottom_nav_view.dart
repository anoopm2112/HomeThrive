import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/ui/views/bottom_nav/auth_nav/auth_bottom_nav_view.dart';
import 'package:fostershare/ui/views/bottom_nav/bottom_nav_view_model.dart';
import 'package:fostershare/ui/views/bottom_nav/guest_nav/guest_bottom_nav_view.dart';
import 'package:stacked/stacked.dart';

class BottomNavView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomNavViewModel>.reactive(
      viewModelBuilder: () => BottomNavViewModel(),
      builder: (context, model, child) =>
          model.isSignedIn ? AuthBottomNavView() : GuestBottomNavView(),
    );
  }
}
