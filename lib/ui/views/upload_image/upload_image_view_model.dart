import 'dart:io';
import 'dart:math';

import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/family_image/family_image.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_family_images_input/get_family_images_input.dart';
import 'package:fostershare/core/models/response/get_family_images_response/get_family_images_response.dart';
import 'package:fostershare/core/services/family_image_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class UploadImageViewModel extends BaseViewModel {
  final _familyImageService = locator<FamilyImageService>();
  final _navigationService = locator<NavigationService>();

  ImagePicker _picker = ImagePicker();
  int _limit = 10;
  GetFamilyImagesResponse _getFamilyImagesResponse;
  List<FamilyImage> familyImages = [];
  int get totalCount => _getFamilyImagesResponse.pageInfo.count;
  bool _loadingImages = false;

  Future<void> onModelReady() async {
    setBusy(true);
    await _loadFamilyImages();
    setBusy(false);
  }

  onOpenCamera() async {
    setBusy(true);
    PickedFile photo;
    try {
      photo = await _picker.getImage(
        source: ImageSource.camera,
      );
    } catch (err) {
      setBusy(false);
    }
    if (photo != null) {
      await _navigationService.navigateTo(Routes.familyImagePreviewView,
          arguments: FamilyImagePreviewViewArguments(imagePath: photo.path));
      await _reloadFamilyImages();
    }
    setBusy(false);
  }

  onOpenGallery() async {
    setBusy(true);
    PickedFile photo;
    try {
      photo = await _picker.getImage(
        source: ImageSource.gallery,
      );
    } catch (err) {
      setBusy(false);
    }
    if (photo != null) {
      await _navigationService.navigateTo(Routes.familyImagePreviewView,
          arguments: FamilyImagePreviewViewArguments(imagePath: photo.path));
      await _reloadFamilyImages();
    }
    setBusy(false);
  }

  onTileCreated(int index) async {
    if (index <= familyImages.length - 5) {
      // Load at 5 images before end
      return;
    }
    if (familyImages.length >= _getFamilyImagesResponse.pageInfo.count) {
      return;
    }
    if (_getFamilyImagesResponse.pageInfo.hasNextPage == false) {
      return;
    }
    if (_loadingImages) {
      return;
    }
    await _loadFamilyImages();
    notifyListeners();
  }

  _loadFamilyImages() async {
    _loadingImages = true;
    var result = await _familyImageService.familyImages(
      GetFamilyImagesInput(
        pagination: CursorPaginationInput(
          cursor: this._getFamilyImagesResponse?.pageInfo?.cursor,
          limit: this._limit,
        ),
      ),
    );
    _getFamilyImagesResponse = result;
    familyImages.addAll(result.items);
    _loadingImages = false;
  }

  _reloadFamilyImages() async {
    _getFamilyImagesResponse = null;
    familyImages.clear();
    await _loadFamilyImages();
  }
}
