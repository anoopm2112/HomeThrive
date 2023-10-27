import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/add_log/log_questions/upload_photos_button/upload_photos_button_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class UploadPhotosButton extends StatelessWidget {
  final void Function(PickedFile file) onImageSelected;

  const UploadPhotosButton({
    Key key,
    this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<UploadPhotosButtonModel>.reactive(
      viewModelBuilder: () => UploadPhotosButtonModel(
        onImageSelected: this.onImageSelected,
      ),
      builder: (context, model, child) => Column(
        children: [
          DottedBorder(
            padding: EdgeInsets.zero,
            borderType: BorderType.RRect,
            radius: Radius.circular(4),
            dashPattern: [8, 4],
            color: Color(0xFF1D334B), // TODO
            strokeWidth: 2,
            child: TextButton(
              onPressed: model.onUploadPhotos,
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF1d334b).withOpacity(.2), // TODO
                minimumSize: Size(50, 62),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Color(0xFF1D334B), // TODO
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localization.uploadPhotos,
                      style: textTheme.bodyText2.copyWith(
                        color: Color(0xFF1D334B),
                        fontSize: getResponsiveSmallFontSize(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (model.showSelectedImageFileName) ...[
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  Icon(Icons.image_outlined),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      model.selectedImageFileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2.copyWith(
                        color: Color(0xFF1D334B), // TODO
                        fontSize: getResponsiveSmallFontSize(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: model.onRemoveImage,
                    child: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
