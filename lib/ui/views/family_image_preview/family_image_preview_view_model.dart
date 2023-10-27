import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/input/create_family_image_input/create_family_image_input.dart';
import 'package:fostershare/core/services/family_image_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';

enum SubmitImageFormField {
  imageName,
}

class FamilyImagePreviewViewModel extends BaseViewModel
    with FormViewModelMixin<SubmitImageFormField> {
  final _familyImageService = locator<FamilyImageService>();
  final _navigationService = locator<NavigationService>();

  FamilyImagePreviewViewModel(this.currentImagePath);

  String currentImagePath;

  Future<void> onModelReady() async {
    setBusy(true);
    addAllFormFields({
      SubmitImageFormField.imageName: FormFieldModel<String>(
        value: "",
      ),
    });
    setBusy(false);
  }

  onSubmitImage() async {
    setBusy(true);
    var name = fieldValue(SubmitImageFormField.imageName);
    var file = basename(currentImagePath);
    await _familyImageService.createFamilyImage(
      CreateFamilyImageInput(
          name: name,
          image: base64.encode(await File(currentImagePath).readAsBytes()),
          file: file),
    );
    _navigationService.back();
    setBusy(false);
  }
}
