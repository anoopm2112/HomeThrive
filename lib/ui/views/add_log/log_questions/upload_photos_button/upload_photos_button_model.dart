import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:stacked/stacked.dart';

class UploadPhotosButtonModel extends BaseViewModel {
  void Function(PickedFile file) _onImageSelected;

  PickedFile _selectedImageFile;

  bool get showSelectedImageFileName => this.selectedImageFileName != null;
  String get selectedImageFileName => this._selectedImageFile != null
      ? basename(this._selectedImageFile.path)
      : null;

  UploadPhotosButtonModel({
    void Function(PickedFile file) onImageSelected,
  }) : this._onImageSelected = onImageSelected;

  Future<void> onUploadPhotos() async {
    final PickedFile file = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (file != null) {
      _updateSelectedImage(file);
    }

    notifyListeners();
  }

  void _updateSelectedImage(PickedFile file) {
    this._selectedImageFile = file;

    this._onImageSelected?.call(file);
    notifyListeners();
  }

  void onRemoveImage() {
    _updateSelectedImage(null);
  }
}
