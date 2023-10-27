import 'package:flutter/material.dart';
import 'package:fostershare/ui/views/foster_details_registration/foster_details_registration_view_model.dart';
import 'package:stacked/stacked.dart';

class FosterDetailsRegistrationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FosterDetailsRegistrationViewModel>.reactive(
      viewModelBuilder: () => FosterDetailsRegistrationViewModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
